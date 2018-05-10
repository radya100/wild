#!/bin/bash

# Определение переменных
#source connections/jecht.conn
source connections/logos.conn
source connections/buran_ch.conn
#source connections/alice.conn
export lb=$(($(clickhouse-client --query="select max(rv) from EmployeeInOut where rv > 0")))
export rows=50000
export select_file="sql/eio_select.sql"
export insert_file="sql/eio_insert.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' \
| sed 's/_lb_/'$lb'/' \
| sed 's/_rows_/'$rows'/')
export insert_sql=$(<$insert_file)
printf "$select_sql"

#Запись данных в КХ
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)
export begin_ss_opt=$(date +%s%3N)
clickhouse-client -u $user_ch --password $pas_ch --query="OPTIMIZE TABLE EmployeeInOut"
export end_ss=$(date +%s%3N)

#Логирование загрузки
export row=$(clickhouse-client --query="select count(1) from EmployeeInOut where rv>$lb")
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(10, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client -u $user_ch --password $pas_ch --query="$log_sql"

#printf "$insert_sql"
