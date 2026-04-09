#!/usr/bin/env bash
# schedule-sms.sh - Schedule an SMS for future delivery via Twilio Messaging Service
# Usage: schedule-sms.sh <to_number> <message_body> <iso8601_send_at>
# Example: schedule-sms.sh "+15551234567" "Your reminder" "2026-04-10T14:00:00Z"
# Requirements: TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_MESSAGING_SERVICE_SID env vars
# Constraints: SendAt must be >= 15 min in the future, <= 7 days from now

set -euo pipefail

TO="$1"
BODY="$2"
SEND_AT="$3"

if [[ -z "$TWILIO_ACCOUNT_SID" ]] || [[ -z "$TWILIO_AUTH_TOKEN" ]] || [[ -z "$TWILIO_MESSAGING_SERVICE_SID" ]]; then
  echo "Error: Twilio credentials not configured (TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_MESSAGING_SERVICE_SID)"
  exit 1
fi

echo "Scheduling SMS to ${TO} at ${SEND_AT}..."
RESPONSE=$(curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json" \
  -u "${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}" \
  --data-urlencode "To=${TO}" \
  --data-urlencode "MessagingServiceSid=${TWILIO_MESSAGING_SERVICE_SID}" \
  --data-urlencode "Body=${BODY}" \
  --data-urlencode "ScheduleType=fixed" \
  --data-urlencode "SendAt=${SEND_AT}")

MESSAGE_SID=$(echo "$RESPONSE" | jq -r '.sid // empty')
STATUS=$(echo "$RESPONSE" | jq -r '.status // empty')
ERROR_MESSAGE=$(echo "$RESPONSE" | jq -r '.message // empty')

if [[ -n "$MESSAGE_SID" ]]; then
  echo "✅ SMS scheduled successfully!"
  echo "Message SID: $MESSAGE_SID"
  echo "Status: $STATUS"
  echo "Send at: ${SEND_AT}"
  echo ""
  echo "To cancel:"
  echo "  ./cancel-sms.sh $MESSAGE_SID"
else
  echo "❌ SMS scheduling failed:"
  echo "$ERROR_MESSAGE"
  exit 1
fi
