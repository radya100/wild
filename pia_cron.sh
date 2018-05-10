#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "PlaceInventoryAssignmentChange")
if [ -z $insert_pid ]; then
        bash pia_load.sh
else
        echo "PlaceInventoryAssignmentChange Process load: "$insert_pid >> logs/pia_cron.err.log
fi

