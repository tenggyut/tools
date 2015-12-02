#! /bin/bash

if [ -z $1 ] || [ -z $2 ]; then
  echo "usage tomcat_home access_port [shutdown_port] [ajt_port] [redirect_port]"
  exit
fi

TOMCAT_HOME=$1
ACCESS_PORT=$2


if [ -z $3 ]; then
  SHUTDOWN_PORT=$(($2+1))
else
  SHUTDOWN_PORT=$3
fi

if [ -z $4 ]; then
  AJT_PORT=$(($2+3))
else
  AJT_PORT=$4
fi

if [ -z $5 ]; then
  REDIRECT_PORT=$(($2+2))
else
  REDIRECT_PORT=$5
fi

TOMCAT_SERVER_CONF=$TOMCAT_HOME/conf/server.xml

echo "changing port: shutdown_port=${SHUTDOWN_PORT} access_port=${ACCESS_PORT} ajt_port=${AJT_PORT} redirect_port=${REDIRECT_PORT}"

perl -pi -e "s/<Server port=\"\d+\" shutdown=\"SHUTDOWN\">/<Server port=\"${SHUTDOWN_PORT}\" shutdown=\"SHUTDOWN\">/g" $TOMCAT_SERVER_CONF
perl -pi -e "s/<Connector port=\"\d+\" protocol=\"HTTP\/1.1\"/<Connector port=\"${ACCESS_PORT}\" protocol=\"HTTP\/1.1\"/g" $TOMCAT_SERVER_CONF
perl -pi -e "s/redirectPort=\"\d+\" \/>/redirectPort=\"${REDIRECT_PORT}\" \/>/g" $TOMCAT_SERVER_CONF
perl -pi -e "s/<Connector port=\"\d+\" protocol=\"AJP\/1.3\" redirectPort=\"\d+\" \/>/<Connector port=\"${AJT_PORT}\" protocol=\"AJP\/1.3\" redirectPort=\"${REDIRECT_PORT}\" \/>/g" $TOMCAT_SERVER_CONF

ENV_SH=$TOMCAT_HOME/bin/setenv.sh

touch $ENV_SH
chmod +x $ENV_SH

echo "#! /bin/bash" >> $ENV_SH
echo "export CATALINA_HOME=${TOMCAT_HOME}" >> $ENV_SH
sed -i "97i $ENV_SH" $TOMCAT_HOME/bin/catalina.sh

echo "done"
