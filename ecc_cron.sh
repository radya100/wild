#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "ecc")
if [ -z $insert_pid ]; then
        bash ecc_load.sh
else
        echo "EmployeeConveyorChange Process load: "$insert_pid >> logs/ecc_cron.err.log
fi

