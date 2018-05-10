#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "laborer_work_assignment")
if [ -z $insert_pid ]; then
        bash lwa_load.sh
else
        echo "laborer_work_assignment Process load: "$insert_pid >> logs/lwa_cron.err.log
fi

