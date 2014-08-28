#! /bin/bash

ZOOKEEPER_HOME=/home/hadoop/zookeeper

quorum=`ssh hadoop@$ZOOKEEPER_HOSTNAME cat $ZOOKEEPER_HOME/conf/zoo.cfg | grep server | awk 'BEGIN{FS="\n"}{for (i=1; i<=NF; i++) print $i}'`

for var in ${quorum[@]};do
   quorum_node=`echo $var | awk '{split($0,a,"[=:]"); print a[2]}'`
   scp -r $ZOOKEEPER_HOME hadoop@$quorum_node:$ZOOKEEPER_HOME
done
