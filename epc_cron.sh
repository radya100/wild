#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "epc")
if [ -z $insert_pid ]; then
        bash epc_load.sh
else
        echo "EmployeePackChange Process load: "$insert_pid >> logs/epc_cron.err.log
fi

