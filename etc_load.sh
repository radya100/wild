#!/bin/bash

# Определение переменных
#source connections/jecht.conn
source connections/omega.conn
source connections/buran_ch.conn

export lb_file="logs/etc.mli"
export lb=$(<$lb_file)
export rows=50000
export drop_stage_sql=$(<"sql/etc/drop_stage.sql")
export make_stage_sql=$(<"sql/etc/make_stage.sql")
export select_file="sql/etc/select.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' | sed 's/_lb_/'$lb'/' | sed 's/_rows_/'$rows'/')
export insert_sql=$(<$"sql/etc/insert.sql")
export fill_basic_file="sql/etc/fill_basic.sql"
#Пересоздаем временную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query="$drop_stage_sql"
clickhouse-client -u $user_ch --password $pas_ch --query="$make_stage_sql"

#Запись данных в stage
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g;s/\.//g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)

#Определяем размерность stage - для формирования подзапроса
export mli=$(clickhouse-client --query="select max(log_id) from stage_etc")
export row=$(clickhouse-client --query="select count() from stage_etc")

#Формирование подзапроса к stage
export fill_basic_sql=$(cat $fill_basic_file | tr '\n' ' ')
export begin_ss_opt=$(date +%s%3N)

if (( mli>0 )); then #Запись в основную таблицу и фиксирование log_id в файле
	clickhouse-client -u $user_ch --password $pas_ch --query="$fill_basic_sql"
	echo $mli>logs/etc.mli
fi
export end_ss=$(date +%s%3N)

#Логирование загрузки
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(22, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client -u $user_ch --password $pas_ch --query="$log_sql"
