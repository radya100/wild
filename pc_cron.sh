#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "PalletChange")
if [ -z $insert_pid ]; then
        bash pc_load.sh
else
        echo "PalletChange Process load: "$insert_pid >> logs/pc_cron.err.log
fi

