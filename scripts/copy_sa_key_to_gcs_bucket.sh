#!/bin/sh

# Copies file to a GCS storage bucket
# 
# . copy_sa_key_to_gcs_bucket.sh $SERVICE_ACCOUNT_KEY_PATH $STORAGE_BUCKET_NAME 
# Pre-requisites:
# gcloud services enable storage-api.googleapis.com
# gcloud services enable storage-component.googleapis.com 

SERVICE_ACCOUNT_KEY_PATH=$1
STORAGE_BUCKET_NAME=$2

gsutil cp $SERVICE_ACCOUNT_KEY_PATH $STORAGE_BUCKET_NAME/secrets/


export EXPORTED_BUCKET_SECRETS_PATH=$STORAGE_BUCKET_NAME/secrets

