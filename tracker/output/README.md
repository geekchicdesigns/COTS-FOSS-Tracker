### How to PROVE everything is wired (checklist)
After one pipeline run, confirm:
^BGitLab CI^B
  - scan_versions job succeeds
  - Artifact tracker/output/argocd_apps.json exists
  - publish_child_report runs without fetching Argo CD itself

^BArgo CD^B
  - No inbound connections from GitLab
  - Read-only token usage only

^BConfluence^B
  - Page updated
  - Approval Status reflects computed value
  - CI Evidence link points to job URL
  - Grafana link static or generated

If all three pass → you are wired correctly.
