#! /bin/bash

echo "start to sync configuration"
cp /home/hadoop/impala/default/impala /etc/default/impala
cp -r /home/hadoop/impala/conf/ /etc/impala/ 
cp /home/hadoop/impala/default/bigtop-utils /etc/default/bigtop-utils 
mkdir /var/run/hadoop-hdfs
chown impala.impala /var/run/hadoop-hdfs
