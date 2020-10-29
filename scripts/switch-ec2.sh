#!/usr/bin/env bash

set -e

SCRIPT_NAME=$(basename $0)

USAGE="$SCRIPT_NAME <instance-name> <instance-type>\nFor example: $SCRIPT_NAME akeller-dev-box t3.2xlarge"

if [ -z "$1" ]; then
  echo -e $USAGE
  exit 1
elif [ -z "$2" ]; then
  echo -e $USAGE
  exit 1
elif [[ $* == *-h* ]]; then
  echo -e $USAGE
  exit 0
else
  INSTANCE_NAME=$1
  INSTANCE_TYPE=$2
fi

INSTANCE_ID=$(aws ec2 describe-instances \
  --filter "Name=tag:Name,Values=${INSTANCE_NAME}" \
  --query "Reservations[].Instances[].InstanceId[]" \
  --output text)

INITIAL_INSTANCE_TYPE=$(aws ec2 describe-instance-attribute \
  --instance-id $INSTANCE_ID \
  --attribute instanceType \
  --query 'InstanceType.Value' \
  --output text)

if [ $INITIAL_INSTANCE_TYPE == $INSTANCE_TYPE ]; then
  echo "$INSTANCE_NAME is already $INSTANCE_TYPE"
  exit 0
fi

stop-ec2 $INSTANCE_NAME

aws ec2 modify-instance-attribute \
  --instance-id $INSTANCE_ID \
  --instance-type $INSTANCE_TYPE

FINAL_INSTANCE_TYPE=$(aws ec2 describe-instance-attribute \
  --instance-id $INSTANCE_ID \
  --attribute instanceType \
  --query 'InstanceType.Value' \
  --output text)

MESSAGE="Switched $INSTANCE_NAME from $INITIAL_INSTANCE_TYPE to $FINAL_INSTANCE_TYPE"
echo $MESSAGE
notify-send -i terminal "$MESSAGE"
