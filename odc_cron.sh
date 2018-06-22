#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "odc")
if [ -z $insert_pid ]; then
        bash odc_load.sh
else
        echo "OrderDetailChange Process load: "$insert_pid >> logs/odc_cron.err.log
fi

