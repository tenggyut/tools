#! /bin/bash

if [ -z $1 ] || [ -z $2] || [ -z $3 ]; then
    echo "usage groupId artifactId version"
    exit
fi


mvn versions:set -DgenerateBackupPoms=false -DartifactId=$2 -DgroupId=$1 -DnewVersion=$3
