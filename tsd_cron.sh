#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "tsd")
if [ -z $insert_pid ]; then
        bash tsd_load.sh
else
        echo "TSDChange Process load: "$insert_pid >> logs/tsd_cron.err.log
fi

