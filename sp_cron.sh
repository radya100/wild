#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "StoragePlaceChange")
if [ -z $insert_pid ]; then
        bash sp_load.sh
else
        echo "StoragePlaceChange Process load: "$insert_pid >> logs/sp_cron.err.log
fi

