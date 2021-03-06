#!/bin/sh

source env_vars

if [ -f $STATE_FILE ]; then
    echo "$STATE_FILE already exists.  Please run ./teardown.sh to delete all resources and then you will be able to rerun ./setup.sh."
    
    exit 
fi

# random 4-digit number to follow
PROJECT_NAME=$NAME-$((1000 + RANDOM % 8999))

# write to state file
echo "Writing to state file: $STATE_FILE"
cat > $STATE_FILE << EOF
NAME=$PROJECT_NAME
EOF

gcloud projects create $PROJECT_NAME

PROJECT_ID=$PROJECT_NAME 
BILLING_ID=${BILLING_ID:-"$(gcloud beta billing accounts list  | sed -n 2p | tr -s ' ' | cut -d ' ' -f1)"}

if [[ $BILLING_ID = "" ]]; then
    echo "An error has occurred: Billing account id does not exist. Please manually set it in env_vars file as BILLING_ID=[BILLING_ID_HERE]"  
    exit 
fi

echo "Linking billing account: " $BILLING_ID
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ID

declare -a SERVICES_TO_ENABLE=("cloudbilling.googleapis.com" \
    "compute.googleapis.com" \              # GCE
    "pubsub.googleapis.com" \               # PubSub
    "iam.googleapis.com" \                  # IAM
    "iamcredentials.googleapis.com" \       # IAM
    "storage-api.googleapis.com" \          # GCS
    "storage-component.googleapis.com " \   # GCS
)

for SERVICE in "${SERVICES_TO_ENABLE[@]}"
do
   echo "Enabling service: $SERVICE"
   gcloud services enable $SERVICE --project $PROJECT_ID
done

# additional scripts
. scripts/create_pub_sub.sh $PROJECT_ID
. scripts/create_service_account.sh $PROJECT_ID
. scripts/create_storage_bucket.sh $PROJECT_ID
. scripts/create_service_account_key.sh $PROJECT_ID $EXPORTED_SERVICE_ACCOUNT_EMAIL
. scripts/copy_sa_key_to_gcs_bucket.sh $EXPORTED_SERVICE_ACCOUNT_KEY_PATH $EXPORTED_BUCKET_NAME 
. scripts/kms.sh $PROJECT_ID # setup kms enc/dec

URL="https://console.cloud.google.com/home/dashboard?project=$PROJECT_ID"
echo "Project setup completed.  Access URL here: $URL"
open $URL
