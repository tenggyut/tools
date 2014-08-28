#! /bin/bash

HADOOP_HOME=/home/hadoop/hadoop
HBASE_HOME=/home/hadoop/hbase
ZOO_HOME=/home/hadoop/zookeeper

while getopts "h:i:" arg
do
  case $arg in
       i)
         HOSTNAME_IP=$OPTARG
         ;;
       h)
         HOSTNAME_NAME=$OPTARG
         ;;
       ?)
         echo "invalid argument"
         exit 1
         ;;
  esac
done

if [ -z "${HOSTNAME_IP}" ] || [ -z "${HOSTNAME_NAME}" ] ; then
  echo "the required arguments are not fullfilled"
  exit 1
fi

#if any error occured, exit the script
set -e


echo "add slave and region server"
printf "${HOSTNAME_NAME}\n" >> $HADOOP_HOME/conf/slaves
printf "${HOSTNAME_NAME}\n" >> $HBASE_HOME/conf/regionservers
#sudo -s 123asd\n printf "${HOSTNAME_IP} ${HOSTNAME_NAME}\n" >> /etc/hosts


echo "sync installation and config"
INDEX=0
while read line
do
  nodes[$INDEX]=$line
  INDEX=$[$INDEX+1]
  ssh hadoop@$line "printf \"${HOSTNAME_IP} ${HOSTNAME_NAME}\n\" >> /etc/hosts"
done <  $HBASE_HOME/conf/regionservers

echo "sync hadoop and hbase installation"
rsync -av --exclude=src/ --exclude=logs/* --exclude=cloudera/ --exclude=examples*/ $HADOOP_HOME hadoop@$HOSTNAME_NAME:$HADOOP_HOME
rsync -av --exclude=src/ --exclude=logs/* --exclude=cloudera/ --exclude=examples*/ $HBASE_HOME hadoop@$HOSTNAME_NAME:$HBASE_HOME

for var in ${nodes[@]};do
  scp  $HADOOP_HOME/conf/slaves hadoop@$var:$HADOOP_HOME/conf/slaves
  scp  $HBASE_HOME/conf/regionservers hadoop@$var:$HBASE_HOME/conf/regionservers
done

echo "start hadoop datanode process"
ssh hadoop@$HOSTNAME_NAME $HADOOP_HOME/bin/hadoop-daemon.sh start datanode

echo "start hbase regionserver process"
ssh hadoop@$HOSTNAME_NAME ${HBASE_HOME}/bin/hbase-daemon.sh start regionserver

