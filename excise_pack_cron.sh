#!/bin/bash
export PATH="$PATH:/opt/mssql-tools/bin"
cd ~/loads

export insert_pid=$(/home/gorbachev/loads/check_load.sh "excise_pack")
if [ -z $insert_pid ]; then
        bash excise_pack_load.sh
else
        echo "excise_pack Process load: "$insert_pid >> logs/excise_pack_cron.err.log
fi

