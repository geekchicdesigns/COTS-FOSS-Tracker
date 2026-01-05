#!/usr/bin/env bash
set -euo pipefail

: "${CONF_USER_EMAIL:?Missing CONF_USER_EMAIL}"
: "${CONF_API_TOKEN:?Missing CONF_API_TOKEN}"
: "${CONF_BASE_URL:?Missing CONF_BASE_URL}"
: "${CONF_SPACE_KEY:?Missing CONF_SPACE_KEY}"
: "${CONF_PARENT_PAGE_ID:?Missing CONF_PARENT_PAGE_ID}"

CONTENT=$(jq -Rs . < tracker/output/versions.md)

PAYLOAD=$(jq -n \
  --arg title "Version Report - $(date +%F)" \
  --arg parent "$CONF_PARENT_PAGE_ID" \
  --arg space "$CONF_SPACE_KEY" \
  --argjson content "$CONTENT" \
  '{
    type: "page",
    title: $title,
    ancestors: [{ id: $parent }],
    space: { key: $space },
    body: {
      storage: {
        value: $content,
        representation: "storage"
      }
    }
  }')

curl --http1.1 -sS -X POST \
  -u "$CONF_USER_EMAIL:$CONF_API_TOKEN" \
  -H "Content-Type: application/json" \
  "$CONF_BASE_URL/wiki/rest/api/content" \
  -d "$PAYLOAD"
