#!/bin/bash

# Определение переменных
#source connections/jecht.conn
source connections/omega.conn
source connections/buran_ch.conn
#omega.conn
export lb=$(($(clickhouse-client --query="select max(log_id) from ContainerChange")+1))
export rows=49999
export le=$(($lb+$rows))
export select_file="sql/cc_select.sql"
export insert_file="sql/cc_insert.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' \
| sed 's/_lb_/'$lb'/' \
| sed 's/_rows_/'$rows'/')
export insert_sql=$(<$insert_file)

#printf "$select_sql"
#Пересоздаем временную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query="drop table if exists default.stage_ContainerChange"
clickhouse-client -u $user_ch --password $pas_ch --query="CREATE TABLE default.stage_ContainerChange (log_id UInt64,  container_id UInt64,  place_cod UInt64,  employee_id UInt64,  dt DateTime,  super_wave_id UInt64,  part UInt64,  stage UInt64,  street UInt64,  filled_employee_id UInt64,  filled_dt DateTime,  bind_employee_id UInt64,  bind_dt DateTime,  lift_employee_id UInt64,  lift_dt DateTime,  prep_employee_id UInt64,  prep_dt DateTime,  park_employee_id UInt64,  park_dt DateTime,  invent_employee_id UInt64,  invent_dt DateTime,  container_place UInt64,  wave_id UInt64) ENGINE = Memory"

#Запись данных в stage
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)
#Запись в основную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query="insert into ContainerChange (log_id, container_id, place_cod,  employee_id, dt, super_wave_id, part, stage, street, filled_employee_id, filled_dt, bind_employee_id, bind_dt, lift_employee_id, lift_dt, prep_employee_id, prep_dt, park_employee_id, park_dt, invent_employee_id, invent_dt, container_place, wave_id, wh_id, place_type_id) select log_id, container_id, place_cod, employee_id, dt, super_wave_id, part, stage, street, filled_employee_id, filled_dt, bind_employee_id, bind_dt, lift_employee_id, lift_dt, prep_employee_id, prep_dt, park_employee_id, park_dt, invent_employee_id, invent_dt, container_place,  wave_id, dictGetUInt64('StoragePlace','wh_id', place_cod), dictGetUInt64('StoragePlace', 'place_type_id', place_cod) from stage_ContainerChange"
#Оптимизация
export begin_ss_opt=$(date +%s%3N)
clickhouse-client -u $user_ch --password $pas_ch --query="OPTIMIZE TABLE ContainerChange"
export end_ss=$(date +%s%3N)
#printf "$msg"

#Логирование загрузки
export row=$(clickhouse-client --query="select count(1) from default.stage_ContainerChange")
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(9, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client -u $user_ch --password $pas_ch --query="$log_sql"
