#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "ShkLostChange")
if [ -z $insert_pid ]; then
        bash slc_load.sh
else
        echo "ShkLostChange Process load: "$insert_pid >> logs/slc_cron.err.log
fi

