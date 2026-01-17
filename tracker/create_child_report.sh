#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Inputs / Outputs
# ----------------------------
ARGOCD_JSON="${1:-argocd_apps.json}"
OUTPUT_DIR="tracker/output"
OUTPUT_JSON="${OUTPUT_DIR}/app_versions.json"
OUTPUT_MD="${OUTPUT_DIR}/app_versions.md"

mkdir -p "$OUTPUT_DIR"

if [[ ! -f "$ARGOCD_JSON" ]]; then
  echo "ERROR: ArgoCD JSON input not found: $ARGOCD_JSON" >&2
  exit 1
fi

# ----------------------------
# Normalize ArgoCD data
# ----------------------------
jq '
.items[] |
{
  application: .metadata.name,
  namespace: .spec.destination.namespace,
  repo_url: .spec.source.repoURL,
  helm_chart: .spec.source.chart,
  helm_chart_version: .spec.source.targetRevision,
  deployed_revision: .status.sync.revision,
  sync_status: .status.sync.status,
  health_status: .status.health.status,
  last_deployed_at: (.status.history[0].deployedAt // "unknown")
}
' "$ARGOCD_JSON" > "$OUTPUT_JSON"

# ----------------------------
# Generate human-readable Markdown
# ----------------------------
{
  echo "# ArgoCD Application Versions"
  echo
  echo "| Application | Namespace | Chart | Version | Sync | Health | Deployed At |"
  echo "|------------|-----------|-------|---------|------|--------|-------------|"

  jq -r '
  . |
  "| \(.application) | \(.namespace) | \(.helm_chart) | \(.helm_chart_version) | \(.sync_status) | \(.health_status) | \(.last_deployed_at) |"
  ' "$OUTPUT_JSON"

} > "$OUTPUT_MD"

echo "✔ ArgoCD application report generated:"
echo "  - $OUTPUT_JSON"
echo "  - $OUTPUT_MD"

