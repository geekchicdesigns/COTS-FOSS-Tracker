## ARGOCD APP-OF-APPS

## Architectural Direction
  - ArgoCD as source of deployment truth
  - GitLab CI as read-only observer
  - Confluence as reporting / compliance surface
  - Grafana as visualization platform

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

## Wiring GitLab -> ArgoCD
  - This ONE-WAY relationship allows ArgoCD to pull from GitLab.
  - GitLab never talks directly to ArgoCD in normal operations.

| Thing                             | Purpose                    |
| --------------------------------- | -------------------------- |
| GitLab repo credentials in ArgoCD | Let ArgoCD read Git        |
| ArgoCD Application manifest     | Tell ArgoCD _what_ to sync |

### Create GitLab Deploy Token
`Project -> Settings -> Repository -> Deploy Tokens

| Field    | Value             |
| -------- | ----------------- |
| Name     | `argocd-readonly` |
| Username | auto              |
| Scopes   | read_repository   |
| Expiry   | optional          |

Save:
  - Username
  - Token

### Register GitLab repo in ArgoCD
Run this once, from anywhere that can reach ArgoCD:
```
argocd repo add \
  http://gitlab.local/platform/cots-foss-tracker.git \
  --username <DEPLOY_TOKEN_USERNAME> \
  --password <DEPLOY_TOKEN> \
  --insecure-skip-server-verification
```

- This stores credentials inside ArgoCD
- GitLab does not need to know ArgoCD exists

### Create the ArgoCD Application (this is the "wire")
Create this file within repo:
`argocd/apps/cots-foss-tracker.yaml`

### Apply the Application ONCE
From within Kubernetes environment:
`kubectl apply -f argocd/apps/cots-foss-tracker.yaml`

### Confirm ArgoCD wiring - local testing specific to WSL2 | KIND | Docker Compose architecture
`argocd app list`
`argocd app get cots-foss-tracker`


