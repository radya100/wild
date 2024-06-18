#!/bin/bash

cd ~/etl/ci/
source ../buran.conn
export url="http://$user:$password@$host:8123"
export dminute=20
if [ -f ./kim.mli ]; then
        export mindt=$(<./kim.mli)
else
        export mindt=$(echo 'select max(dt_load) as mli from service.mart_ci' | curl $url -d @-)
fi
export maxdt_query=$(cat ./maxdt.sql | sed "s/__pb__/$mindt/" | sed "s/__interval__/$dminute/")
export maxdt=$(echo $maxdt_query | curl $url -d @-)
export query=$(cat ./insert.sql | sed "s/__pb__/'$mindt'/" | sed "s/__pe__/'$maxdt'/")
export msg=$(echo $query | curl --write-out '%{http_code}' --output /dev/null --silent $url -d @-)
if [[ "$msg" == "200" ]]; then
        echo $maxdt>./kim.mli
else
        echo "Error!!" 1>&2
        exit 64
fi
