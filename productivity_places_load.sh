#!/bin/bash

# Определение переменных
source connections/logos.conn
source connections/buran_ch.conn

export drop_file="sql/productivity_places_drop_table.sql"
export create_file="sql/productivity_places_create_table.sql"
export select_file="sql/productivity_places_select.sql"
export insert_file="sql/productivity_places_insert.sql"

export drop_sql=$(<$drop_file)
export create_sql=$(<$create_file)
export select_sql=$(<$select_file)
export insert_sql=$(<$insert_file)

clickhouse-client -u $user_ch --password $pas_ch --query="$drop_sql"
clickhouse-client -u $user_ch --password $pas_ch --query="$create_sql"
export msg=$(/opt/mssql-tools/bin/sqlcmd -S$srv -d$db -U$user -P$pas -Q "$select_sql" -W -h-1 -k -u -s"$(printf '\t')" | sed 's/\x00//g;s/\\//g;s/NULL/0/g' | clickhouse-client -u $user_ch --password $pas_ch --query="$insert_sql" 2>&1)

printf "$msg"
#printf "$create_sql"
#printf "$select_sql"
#printf "$insert_sql"
