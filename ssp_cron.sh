#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "ssp")
if [ -z "$insert_pid" ]; then
        bash ssp_load.sh
else
        echo "ssp Process load: "$insert_pid >> logs/ssp_cron.err.log
fi

