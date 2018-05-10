#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "EmployeeInOut")
if [ -z $insert_pid ]; then
        bash eio_load.sh
else
        echo "EmployeeInOut Process load: "$insert_pid >> logs/eio_cron.err.log
fi

