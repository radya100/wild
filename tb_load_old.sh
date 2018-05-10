#!/bin/bash

# Определение переменных
#source connections/jecht.conn
source connections/omega.conn
source connections/buran_ch.conn
#omega.conn
export lb=$(($(clickhouse-client --query="select max(log_id) from TransferBoxChange")+1))
export rows=49999
export le=$(($lb+$rows))
export select_file="sql/tb_select.sql"
export insert_file="sql/tb_insert.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' \
| sed 's/_lb_/'$lb'/' \
| sed 's/_le_/'$le'/' \
| sed 's/_rows_/'$rows'/')
export insert_sql=$(<$insert_file)

#printf "$select_sql"
#Пересоздаем временную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query="drop table if exists default.stage_TransferBoxChange"
clickhouse-client -u $user_ch --password $pas_ch --query="CREATE TABLE default.stage_TransferBoxChange ( log_id UInt64,  transfer_box_id UInt64,  dt DateTime,  dt_date Date,  employee_id UInt64,  ttn_id UInt64,  place_cod UInt64,  src_office_id UInt64,  shipping_office_id UInt64,  dst_office_id UInt64,  is_deleted UInt8,  sm_id UInt64,  is_jewelry UInt8,  is_create UInt8,  is_close UInt8,  box_type UInt32,  box_weight_100 UInt64,  box_lenght_100 UInt64,  box_width_100 UInt64,  box_height_100 UInt64) ENGINE = Memory"

#Запись данных в stage
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)
#Запись в основную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query=" insert into TransferBoxChange (log_id, transfer_box_id,  dt,  dt_date,  employee_id,  ttn_id,  place_cod,  src_office_id,  shipping_office_id,  dst_office_id,  is_deleted,  sm_id,  is_jewelry,  is_create,  is_close,  box_type,  box_weight_100,  box_lenght_100,  box_width_100,  box_height_100,  wh_id, place_type_id) select log_id, transfer_box_id,  dt,  dt_date,  employee_id,  ttn_id,  place_cod,  src_office_id,  shipping_office_id,  dst_office_id,  is_deleted,  sm_id,  is_jewelry,  is_create,  is_close,  box_type,  box_weight_100,  box_lenght_100,  box_width_100,  box_height_100,  dictGetUInt64('StoragePlace','wh_id', place_cod), dictGetUInt64('StoragePlace', 'place_type_id', place_cod) from stage_TransferBoxChange"
#Оптимизация
export begin_ss_opt=$(date +%s%3N)
clickhouse-client -u $user_ch --password $pas_ch --query="OPTIMIZE TABLE TransferBoxChange"
export end_ss=$(date +%s%3N)
#printf "$msg"

#Логирование загрузки
export row=$(clickhouse-client --query="select count(1) from default.stage_TransferBoxChange")
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(5, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client -u $user_ch --password $pas_ch --query="$log_sql"

