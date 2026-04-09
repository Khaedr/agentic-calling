#!/usr/bin/env bash
# Cancel a previously scheduled Twilio SMS
# Usage: cancel-sms.sh <message_sid>
# Example: cancel-sms.sh "SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
set -euo pipefail
MESSAGE_SID="$1"
curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages/${MESSAGE_SID}.json" \
  -u "${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}" \
  --data-urlencode "Status=canceled"
