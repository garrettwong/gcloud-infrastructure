#!/bin/sh

# Creates a PubSub topic and subscription
# 
# Pre-requisites:
# gcloud services enable pubsub.googleapis.com

echo $PROJECT_ID
PROJECT_ID=$1

export TOPIC="topic"
export TOPIC_SUBSCRIPTION=$TOPIC-TOPIC_SUBSCRIPTION

gcloud pubsub topics create $TOPIC --project $PROJECT_ID
gcloud pubsub subscriptions create $TOPIC_SUBSCRIPTION --topic $TOPIC --project $PROJECT_ID