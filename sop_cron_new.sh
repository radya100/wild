#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "sop")
if [ -z $insert_pid ]; then
        bash sop_load_new.sh
else
        echo "SOP Process load: "$insert_pid >> logs/sop_cron.err.log
fi

