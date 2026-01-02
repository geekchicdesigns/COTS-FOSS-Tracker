#!/usr/bin/env bash
set -e

AUTH=$(printf "%s:%s" "$CONF_USER_EMAIL" "$CONF_API_TOKEN" | base64)

CONTENT=$(jq -Rs . < tracker/output/versions.md)

curl -X POST \
  -H "Authorization: Basic $AUTH" \
  -H "Content-Type: application/json" \
  "$CONF_BASE_URL/wiki/rest/api/content" \
  -d "{
    \"type\": \"page\",
    \"title\": \"COTS/FOSS Version Report - $(date +%F)\",
    \"ancestors\": [{\"id\": \"$CONF_PARENT_PAGE_ID\"}],
    \"space\": {\"key\": \"$CONF_SPACE_KEY\"},
    \"body\": {
      \"storage\": {
        \"value\": $CONTENT,
        \"representation\": \"storage\"
      }
    }
  }"

