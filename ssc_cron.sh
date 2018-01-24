#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "ShkStateChange")
if [ -z $insert_pid ]; then
        bash ssc_load.sh
else
        echo "ShkStateChange Process load: "$insert_pid >> logs/ssc_cron.err.log
fi

