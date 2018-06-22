#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "etc")
if [ -z $insert_pid ]; then
        bash etc_load.sh
else
        echo "EmployeeTableChange Process load: "$insert_pid >> logs/etc_cron.err.log
fi

