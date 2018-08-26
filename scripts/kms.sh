#!/bin/sh

# Creates a KMS key ring
# 
# Pre-requisites:
# https://cloud.google.com/kms/docs/quickstart#encrypt_data
gcloud services enable cloudkms.googleapis.com

export PROJECT_ID=$1
export PROJECT_NUMBER=`gcloud projects describe ${PROJECT_ID} --format='value(projectNumber)'`

export KMS_KEYRING=mykeyring
export KMS_KEY=key1
export KMS_LOCATION=us-central1

export SERVICE_ACCOUNT_A=svc-account-a
export SERVICE_ACCOUNT_A_EMAIL=`echo ${SERVICE_ACCOUNT_A}`@`echo ${PROJECT_ID}`.iam.gserviceaccount.com
export SERVICE_ACCOUNT_A_KEY=$SERVICE_ACCOUNT_A.json

gcloud kms keyrings create $KMS_KEYRING --location $KMS_LOCATION

gcloud kms keys create $KMS_KEY \
     --purpose encryption \
     --keyring $KMS_KEYRING --location $KMS_LOCATION


gcloud kms keys list --keyring $KMS_KEYRING --location $KMS_LOCATION

# encrypt
curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/$PROJECT_ID/locations/$KMS_LOCATION/keyRings/$KMS_KEYRING/cryptoKeys/$KMS_KEY:encrypt" \
-d "{\"plaintext\":\"U29tZSB0ZXh0IHRvIGJlIGVuY3J5cHRlZA==\"}" \
  -H "Authorization:Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type:application/json"

# decrypt
curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/$PROJECT_ID/locations/$KMS_LOCATION/keyRings/$KMS_KEYRING/cryptoKeys/$KMS_KEY:decrypt" \
  -d "{\"ciphertext\":\"CiQA6v7HM/6j59fpdsocAkGwGSmoG58RpIsX6NST/dteF4QYZAwSQgB76/NETUxWvlB7y9DxWQqVxkJHx8Kc4Xb+75f/0iBiZ/vVvNvEX2quwK4KT8RuW4MZwGtWFRc6gAhrnU8MuHPaQw==\"}" \
  -H "Authorization:Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type:application/json"