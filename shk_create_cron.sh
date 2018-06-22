#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "shk_create")
if [ -z "$insert_pid" ]; then
        bash shk_create_load.sh
else
        echo "shk_create Process load: "$insert_pid >> logs/shk_create_cron.err.log
fi

