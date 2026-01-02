#!/usr/bin/env bash
set -e

AUTH=$(printf "%s:%s" "$CONF_USER_EMAIL" "$CONF_API_TOKEN" | base64)
TITLE="COTS/FOSS Version Report"
ENCODED_TITLE=$(printf "%s" "$TITLE" | jq -sRr @uri)

# Find page
PAGE_JSON=$(curl -s \
  -H "Authorization: Basic $AUTH" \
  "$CONF_BASE_URL/wiki/rest/api/content?title=$ENCODED_TITLE&spaceKey=$CONF_SPACE_KEY")

PAGE_ID=$(echo "$PAGE_JSON" | jq -r '.results[0].id')
VERSION=$(echo "$PAGE_JSON" | jq -r '.results[0].version.number')

CONTENT=$(jq -Rs . < tracker/output/versions.md)

# Update page
curl -X PUT \
  -H "Authorization: Basic $AUTH" \
  -H "Content-Type: application/json" \
  "$CONF_BASE_URL/wiki/rest/api/content/$PAGE_ID" \
  -d "{
    \"id\": \"$PAGE_ID\",
    \"type\": \"page\",
    \"title\": \"$TITLE\",
    \"version\": { \"number\": $((VERSION + 1)) },
    \"body\": {
      \"storage\": {
        \"value\": $CONTENT,
        \"representation\": \"storage\"
      }
    }
  }"

