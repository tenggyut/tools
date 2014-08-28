#! /bin/bash

USER=hadoop
HADOOP_HOME=/home/$USER/hadoop


echo "sync installation and config"
INDEX=0
while read line
do
  nodes[$INDEX]=$line
  INDEX=$[$INDEX+1]
done <  $HADOOP_HOME/etc/hadoop/slaves


for var in ${nodes[@]};do
  ssh $USER@$var cp $HADOOP_HOME/logs /home/$USER/logs
  ssh $USER@$var rm -rf $HADOOP_HOME
  rsync -av --exclude=src/ --exclude=logs --exclude=cloudera/ --exclude=examples*/ $HADOOP_HOME $USER@$var:$HADOOP_HOME
  ssh $USER@$var mv /home/$USER/logs $HADOOP_HOME
done
