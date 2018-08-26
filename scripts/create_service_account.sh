#!/bin/sh

# Creates a default service account
# 
# Pre-requisites:
# gcloud services enable iamcredentials.googleapis.com

echo $PROJECT_ID
PROJECT_ID=$1

NAME="sa-deployment"
SERVICE_ACCOUNT_EMAIL=$NAME@$PROJECT_ID.iam.gserviceaccount.com

# gcloud iam roles list
gcloud iam service-accounts create $NAME --display-name $NAME --project $PROJECT_ID

echo "Created SA:" $SERVICE_ACCOUNT_EMAIL

gcloud iam service-accounts add-iam-policy-binding \
    $SERVICE_ACCOUNT_EMAIL \
    --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
    --role 'roles/editor'

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT_EMAIL --role roles/storage.admin
#gcloud projects add-iam-policy-binding $PROJECT_ID --member user:garrettwong@mydomain.com --role roles/storage.admin


export EXPORTED_SERVICE_ACCOUNT_EMAIL=$SERVICE_ACCOUNT_EMAIL