#!/bin/bash



set -u # nounset

set -e # errexit

set -o pipefail # pipefail



if [ "$#" -eq 0 ]; then

  KEYSPACE=""

elif [ "$#" -eq 1 ]; then

  KEYSPACE="$1"

  #nodetool -h localhost -p 7199 clearsnapshot $KEYSPACE

else

  exit 1

fi



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



echo $DIR



BACKUP_SCRIPT="cassandra_backup.sh"

NODES="172.21.0.18"



for node in ${NODES//,/ }

do

  echo "### Copy $DIR/$BACKUP_SCRIPT to $node"

  scp -i ~/.ssh/kube_aws_rsa $DIR/$BACKUP_SCRIPT ubuntu@$node:/tmp/$BACKUP_SCRIPT



  echo "### Execute $BACKUP_SCRIPT on $node"

  ssh -i ~/.ssh/kube_aws_rsa ubuntu@$node /tmp/$BACKUP_SCRIPT "$KEYSPACE"

done;