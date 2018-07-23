#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "spc")
if [ -z $insert_pid ]; then
        bash spc_load_new.sh
else
        echo "ShkPostChange Process load: "$insert_pid >> logs/spc_cron.err.log
fi

