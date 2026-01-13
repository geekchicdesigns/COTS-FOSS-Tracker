## ARGOCD APP-OF-APPS

## GitOp Flow
| Action                 | Owner       |
| ---------------------- | ----------- |
| Define apps + versions | Git         |
| Reconcile state        | ArgoCD      |
| Observe + scrape       | GitLab CI   |
| Audit narrative        | Confluence  |
| Visualize	         | Grafana     |

  - No scripts deploy.
  - No CI mutates the cluster.
  - Everything is auditable.

### Tree Structured Layout
    argocd-apps/
    ├── README.md
    ├── apps
    │   ├── gitlab
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   ├── grafana
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   ├── openssl
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   ├── postgres
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   ├── prometheus
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   ├── redis
    │   │   ├── application.yaml
    │   │   └── values.yaml
    │   └── terraform
    │       ├── application.yaml
    │       └── values.yaml
    ├── projects
    │   └── gitops.yaml
    └── root-app.yaml

### Child Applications populate ArgoCD
  - Example:
  `argocd-apps/apps/<application_name>/application.yaml`
  `argocd-apps/apps/<application_name>/values.yaml`

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

