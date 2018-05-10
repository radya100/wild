#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "ContainerChange")
if [ -z $insert_pid ]; then
        bash cc_load.sh
else
        echo "ContainerChange Process load: "$insert_pid >> logs/cc_cron.err.log
fi

