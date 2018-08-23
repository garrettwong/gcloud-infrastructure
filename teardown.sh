#!/bin/sh

source env_vars

if [ ! -f $STATE_FILE ]; then
    echo "$STATE_FILE doesn't exists.  Nothing to delete."    
    exit 
fi

source $STATE_FILE

echo "Deleting project:" $NAME
gcloud projects delete $NAME --quiet

echo "Deleting state file:" $STATE_FILE
rm $STATE_FILE



echo "Teardown complete"
