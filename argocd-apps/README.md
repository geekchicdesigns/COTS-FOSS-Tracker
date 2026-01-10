## ARGOCD APP-OF-APPS

## GitOp Flow
| Action        | Who does it |
| ------------- | ----------- |
| Define apps   | Git         |
| Read apps     | ArgoCD      |
| Deploy apps   | ArgoCD      |
| Observe state | GitLab CI   |
| Report        | Confluence  |

  - No scripts deploy.
  - No CI mutates the cluster.
  - Everything is auditable.

### Tree Structured Layout
    ../argocd/
    ├── README.md
    ├── apps
    │   ├── argocd.yaml
    │   ├── gitlab.yaml
    │   ├── grafana.yaml
    │   ├── openssl.yaml
    │   ├── postgres.yaml
    │   ├── prometheus.yaml
    │   ├── redis.yaml
    │   └── terraform.yaml
    ├── root-app.yaml		# bootstrap (applied once)
    └── values
        ├── argocd.yaml
        ├── openssl.yaml
        ├── redis.yaml
        └── terraform.yaml

### Child Applications populate ArgoCD
  - Example:
  `argocd-apps/apps/grafana.yaml`

  - Entries created in:
  `/api/v1/applications`

### Bootstrap ArgoCD (one-time only)
Apply the root app once:
  `kubectl apply -f argocd-apps/root-app.yaml`

### Verify in ArgoCD
  - Within CLI:
  `argocd app list`

  - Within API (what CI uses):
  `curl -sk -H "Authorization: Bearer $ARGOCD_TOKEN" \
  https://host.docker.internal:8081/api/v1/applications | jq '.items[].metadata.name`

  - Within ArgoCD UI:
    - Root app: Synced
    - Child apps: Synced / Healthy

