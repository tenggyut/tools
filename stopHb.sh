#! /bin/bash

HBASE_HOME=/home/hadoop/hbase

$HBASE_HOME/bin/hbase-daemon.sh stop master

echo "sync installation and config"
INDEX=0
while read line
do
  nodes[$INDEX]=$line
  INDEX=$[$INDEX+1]
done <  $HBASE_HOME/conf/regionservers

for var in ${nodes[@]};do
  echo "$var"
  ssh hadoop@$var '/home/hadoop/hbase/bin/hbase-daemon.sh stop regionserver'
done
