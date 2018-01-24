#!/bin/bash
table_name=$1
pid=$(pgrep -f "insert into $table_name")
echo $pid
