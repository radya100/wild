#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "TransferBoxChange")
if [ -z $insert_pid ]; then
        bash tb_load.sh
else
        echo "TransferBoxChange Process load: "$insert_pid >> logs/tb_cron.err.log
fi

