#!/usr/bin/env bash
# Schedule an SMS via Twilio Messaging Service (scheduled delivery)
# Usage: schedule-sms.sh <to_number> <message_body> <iso8601_send_at>
# Example: schedule-sms.sh "+15551234567" "Your reminder" "2026-04-10T14:00:00Z"
# Outputs JSON with .sid field (store for cancellation)
# Requirements: TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_MESSAGING_SERVICE_SID env vars
# Constraints: SendAt must be >= 15 min in the future, <= 7 days from now
set -euo pipefail
TO="$1"
BODY="$2"
SEND_AT="$3"
curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json" \
  -u "${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}" \
  --data-urlencode "To=${TO}" \
  --data-urlencode "MessagingServiceSid=${TWILIO_MESSAGING_SERVICE_SID}" \
  --data-urlencode "Body=${BODY}" \
  --data-urlencode "ScheduleType=fixed" \
  --data-urlencode "SendAt=${SEND_AT}"
