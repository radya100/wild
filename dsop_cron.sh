#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "dsop")
if [ -z $insert_pid ]; then
        bash dsop_load.sh
else
        echo "DocShkOnPlaceChange Process load: "$insert_pid >> logs/dsop_cron.err.log
fi

