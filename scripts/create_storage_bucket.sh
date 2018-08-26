#!/bin/sh

# Creates a GCS storage bucket
# 
# Pre-requisites:
# gcloud services enable storage-api.googleapis.com
# gcloud services enable storage-component.googleapis.com 

echo $PROJECT_ID
PROJECT_ID=$1
BUCKET_NAME=$2

# randomize with a uuid - first 13 chars
STORAGE_BUCKET_NAME=gs://storage-"$(uuidgen | cut -d '-' -f1 -f2 | tr '[:upper:]' '[:lower:]')"

gsutil mb  -p $PROJECT_ID $STORAGE_BUCKET_NAME


export EXPORTED_BUCKET_NAME=$STORAGE_BUCKET_NAME

