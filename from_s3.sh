#!/bin/bash

source /etc/bash_etl/onefactor/onefactor.conn
export insert_file=/etc/bash_etl/onefactor/onefactor.sql
for key in aws s3api list-objects --profile onefactor --endpoint-url=https://hb.bizmrg.com --bucket onefactor | jq -r '.Contents[].Key' | sed -e '/\//d' | grep csv.gz
do
        export insert_sql=$(cat $insert_file | sed "s/__file__/$key/g")
        export msg=$(clickhouse-client -m -n --host $host --user $user --password $pass --query="$insert_sql" 2>&1)
        if [ -z "$msg" ]
                then aws s3 mv --profile onefactor --endpoint-url=https://hb.bizmrg.com s3://onefactor/$key s3://onefactor/Processed/$key
                else aws s3 mv --profile onefactor --endpoint-url=https://hb.bizmrg.com s3://onefactor/$key s3://onefactor/Error/$key
        fi
done
