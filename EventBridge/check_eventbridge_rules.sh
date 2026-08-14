#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
RULE_PREFIX="${1:-ec2-}"
START_RULE="${2:-ec2-start-9pm}"
STOP_RULE="${3:-ec2-stop-midnight}"

echo "Listing EventBridge rules with prefix: ${RULE_PREFIX} in region: ${REGION}"
aws events list-rules \
  --name-prefix "${RULE_PREFIX}" \
  --region "${REGION}" \
  --output table

echo
echo "Listing targets for rule: ${START_RULE}"
aws events list-targets-by-rule \
  --rule "${START_RULE}" \
  --region "${REGION}" \
  --output table

echo
echo "Listing targets for rule: ${STOP_RULE}"
aws events list-targets-by-rule \
  --rule "${STOP_RULE}" \
  --region "${REGION}" \
  --output table
