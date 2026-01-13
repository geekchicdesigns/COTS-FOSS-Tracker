## ARGOCD APP-OF-APPS

## GitOp Flow
| Action        | Who does it |
| ------------- | ----------- |
| Define apps   | Git         |
| Read apps     | ArgoCD      |
| Deploy apps   | ArgoCD      |
| Observe state | GitLab CI   |
| Report        | Confluence  |
| Visualize	| Grafana     |

  - No scripts deploy.
  - No CI mutates the cluster.
  - Everything is auditable.

### Tree Structured Layout
argocd-apps/
├── README.md
├── root-app.yaml                 # App-of-apps (bootstrap)
├── projects/
│   └── gitops.yaml               # AppProject (RBAC + scope)
├── apps/
│   ├── grafana/
│   │   ├── application.yaml      # ArgoCD Application
│   │   └── values.yaml           # Version pinning
│   ├── gitlab/
│   │   ├── application.yaml
│   │   └── values.yaml
│   ├── postgres/
│   │   ├── application.yaml
│   │   └── values.yaml
│   └── redis/
│       ├── application.yaml
│       └── values.yaml

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

