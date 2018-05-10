#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "bic")
if [ -z $insert_pid ]; then
        bash bic_load.sh
else
        echo "BIC Process load: "$insert_pid >> logs/bic_cron.err.log
fi

