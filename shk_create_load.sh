#!/bin/bash

# Определение переменных
#source connections/jecht.conn
source connections/omega.conn
source connections/buran_ch.conn

export lb_file="logs/shk_create.mli"
export lb=$(<$lb_file)
export rows=50000
export drop_stage_sql=$(<"sql/shk_create/drop_stage.sql")
export make_stage_sql=$(<"sql/shk_create/make_stage.sql")
export select_file="sql/shk_create/select.sql"
export select_sql=$(cat $select_file | tr '\n' ' ' \
| sed 's/_lb_/'$lb'/' \
| sed 's/_rows_/'$rows'/')
export insert_sql=$(<$"sql/shk_create/insert.sql")
export fill_basic_file="sql/shk_create/fill_basic.sql"
export fill_productivity_file="sql/shk_create/fill_brigade_prod.sql"
#Пересоздаем временную таблицу
clickhouse-client -u $user_ch --password $pas_ch --query="$drop_stage_sql"
clickhouse-client -u $user_ch --password $pas_ch --query="$make_stage_sql"

#Запись данных в stage
export begin_ss=$(date +%s%3N)
export pb=$(date +%Y-%m-%dT%H:%M:%S)
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g;s/\.//g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)

#Определяем размерность stage - для формирования подзапроса
export pb_s=$(clickhouse-client --query="select toDate(min(dt)) as pb from stage_shk_create")
export pe_s=$(clickhouse-client --query="select toDate(max(dt)) as pe from stage_shk_create")
export mli=$(clickhouse-client --query="select max(log_id) from stage_shk_create")
export row=$(clickhouse-client --query="select count() from stage_shk_create")
export lb_s=$(clickhouse-client --query="select min(brigade_id) as lb from stage_shk_create")
export le_s=$(clickhouse-client --query="select max(brigade_id) as le from stage_shk_create")

#Формирование подзапроса к stage
export fill_basic_sql=$(cat $fill_basic_file | tr '\n' ' ')
export fill_productivity_sql=$(cat $fill_productivity_file | tr '\n' ' ' | sed 's/_lb_/'$lb_s'/g' | sed 's/_le_/'$le_s'/g')
export begin_ss_opt=$(date +%s%3N)

if (( mli>0 )); then #Запись в основную таблицу и фиксирование log_id в файле
	clickhouse-client -u $user_ch --password $pas_ch --query="$fill_basic_sql"
	clickhouse-client -u $user_ch --password $pas_ch --query="$fill_productivity_sql"
	echo $mli>logs/shk_create.mli
fi
export end_ss=$(date +%s%3N)

#Логирование загрузки
export log_sql="insert into load_log(table_id, pb, event_date, rows, sec, sec_opt, msg) values(20, '$pb', '$(date -I)', $row, $(($begin_ss_opt-$begin_ss)), $(($end_ss-$begin_ss_opt)), '$msg')"
clickhouse-client -u $user_ch --password $pas_ch --query="$log_sql"
