#!/usr/bin/env bash

set -e

export AWS_PAGER=""

SCRIPT_NAME=$(basename $0)

USAGE="$SCRIPT_NAME <instance-name>\nFor example: $SCRIPT_NAME akeller-dev-box"

if [ -z "$1" ]; then
  echo -e $USAGE
  exit 1
elif [[ $* == *-h* ]]; then
  echo $USAGE
  exit 0
else
  INSTANCE_NAME=$1
fi

INSTANCE_ID=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=${INSTANCE_NAME}" --query "Reservations[].Instances[].InstanceId[]" --output text)

INSTANCE_STATE=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[].Instances[].State[].Name" | jq '.[]')

if [ "$INSTANCE_STATE" == '"running"' ]; then
  echo "$INSTANCE_NAME is already running"
else
  aws ec2 start-instances --instance-id $INSTANCE_ID

  while [ '"running"' != $(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[].Instances[].State[].Name" | jq '.[]') ]
  do
    sleep 1
  done

  notify-send -i terminal "Started $INSTANCE_NAME"
fi

ssh -o "StrictHostKeyChecking=no" ec2-${INSTANCE_NAME}
