#!/bin/bash

# Определение переменных
source connections/jecht.conn
export lb=$(($(clickhouse-client --query="select max(log_id) from ShkPostChange")+1))
#printf "$lb"
export rows=30000
export le=$(($lb+$rows))
export select_file="sql/spc_select.sql"
export insert_file="sql/spc_insert.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' \
| sed 's/_lb_/'$lb'/' \
| sed 's/_le_/'$le'/' \
| sed 's/_rows_/'$rows'/')
export insert_sql=$(<$insert_file)

#Запись данных в КХ
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g' | clickhouse-client --query="$insert_sql" 2>&1)
export begin_ss_opt=$(date +%s%3N)
clickhouse-client --query="OPTIMIZE TABLE ShkPostChange"
export end_ss=$(date +%s%3N)

#Логирование загрузки
export row=$(clickhouse-client --query="select count(1) from ShkPostChange where log_id>$lb")
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(2, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client --query="$log_sql"

#printf "$insert_sql"