#! /bin/bash

USER=hadoop
HBASE_HOME=/home/$USER/hbase

echo "sync installation and config"
INDEX=0
while read line
do
  nodes[$INDEX]=$line
  INDEX=$[$INDEX+1]
done <  $HBASE_HOME/conf/regionservers

for var in ${nodes[@]};do
  ssh $USER@$var cp $HBASE_HOME/logs /home/$USER/logs
  ssh $USER@$var rm -rf $HBASE_HOME
  rsync -av --exclude=src/ --exclude=logs --exclude=docs  $HBASE_HOME $USER@$var:$HBASE_HOME 
  ssh $USER@$var mv /home/$USER/logs $HBASE_HOME
done
