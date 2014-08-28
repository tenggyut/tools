#! /bin/bash

ZOOKEEPER_HOME=/home/hadoop/zookeeper

while getopts "h:o" arg
do
  case $arg in
       h)
         ZOOKEEPER_HOSTNAME=$OPTARG
         ;;
       o)
         OPERATION=$OPTARG
         ;;
       ?)
         echo "invalid argument"
         exit 1
         ;;
  esac
done

if [ -z "$ZOOKEEPER_HOSTNAME" ]; then
  echo "please passing one zookeeper node's hostname, anyone"
  exit 1;
fi

quorum=`ssh hadoop@$ZOOKEEPER_HOSTNAME cat $ZOOKEEPER_HOME/conf/zoo.cfg | grep server | awk 'BEGIN{FS="\n"}{for (i=1; i<=NF; i++) print $i}'`

for var in ${quorum[@]};do
   quorum_node=`echo $var | awk '{split($0,a,"[=:]"); print a[2]}'`
   ssh hadoop@$quorum_node $ZOOKEEPER_HOME/bin/zkServer.sh $OPERATION 
done
