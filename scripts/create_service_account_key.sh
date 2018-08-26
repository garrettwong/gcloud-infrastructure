#!/bin/sh

# Creates a service account key 
# 
# . create_service_account_key $PROJECT_ID $SERVICE_ACCOUNT_EMAIL
# Pre-requisites:
# gcloud services enable {FILLMEIN}

echo $PROJECT_ID
PROJECT_ID=$1
SERVICE_ACCOUNT_EMAIL=$2

echo "Creating SA Key:" $SERVICE_ACCOUNT_EMAIL

gcloud iam service-accounts keys create \
    --iam-account $SERVICE_ACCOUNT_EMAIL \
    $SERVICE_ACCOUNT_EMAIL-key.json \
    --project $PROJECT_ID


export EXPORTED_SERVICE_ACCOUNT_KEY_PATH=$SERVICE_ACCOUNT_EMAIL-key.json