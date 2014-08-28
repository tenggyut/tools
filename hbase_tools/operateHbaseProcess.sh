#! /bin/bash

HBASE_DAEMON_PATH=/home/hadoop/hbase/bin/hbase-daemon.sh

while getopts "h:t:o:" arg
do
  case $arg in
       h)
         HOSTNAME_IP=$OPTARG
         ;;
       t)
         PROCESSTYPE=$OPTARG
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

if [ -z "${HOSTNAME_IP}" ] || [ -z "${PROCESSTYPE}" ] || [ -z "${OPERATION}" ]; then
  echo "the required arguments are not fullfilled"
  exit 1
fi

echo "start to ${OPERATION} the ${PROCESSTYPE} on ${HOSTNAME_IP}"

ssh hadoop@${HOSTNAME_IP} "${HBASE_DAEMON_PATH}" "${OPERATION}" "${PROCESSTYPE}"

if [ ${PROCESSTYPE} == "master" ]; then
  PROCESS_NAME="HMaster"
else
  PROCESS_NAME="HRegionServer"
fi

PID=`ssh hadoop@${HOSTNAME_IP} jps | grep ${PROCESS_NAME} | awk -F" " '{print $1}'`

if [ ${OPERATION} == "stop" ] && [ -z ${PID} ]; then
  echo "stop ${PROCESSTYPE} successful"
elif [ ${PID} -gt 0 ] && [ ${OPERATION} == "start" ]; then
  echo "start ${PROCESSTYPE} successful"
else
  echo "${PROCESSTYPE} failed"
fi

exit 0
