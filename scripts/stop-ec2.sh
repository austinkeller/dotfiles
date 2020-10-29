#!/usr/bin/env bash

set -e

SCRIPT_NAME=$(basename $0)

USAGE="$SCRIPT_NAME <instance-name>\nFor example: $SCRIPT_NAME akeller-dev-box"

if [ -z "$1" ]; then
  echo -e $USAGE
  exit 1
elif [[ $* == *-h* ]]; then
  echo -e $USAGE
  exit 0
else
  INSTANCE_NAME=$1
fi

INSTANCE_ID=$(aws ec2 describe-instances \
  --filter "Name=tag:Name,Values=${INSTANCE_NAME}" \
  --query "Reservations[].Instances[].InstanceId[]" \
  --output text)

aws ec2 stop-instances --instance-id $INSTANCE_ID

INSTANCE_STATE=''

while [ '"stopped"' != "$INSTANCE_STATE" ]
do
  sleep 1
  INSTANCE_STATE=$(aws ec2 describe-instances \
    --instance-id $INSTANCE_ID \
    --query "Reservations[].Instances[].State[].Name" \
    | jq '.[]')
done

notify-send -i terminal "Stopped $INSTANCE_NAME"
