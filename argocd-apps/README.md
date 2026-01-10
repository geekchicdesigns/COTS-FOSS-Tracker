## ARGOCD APP-OF-APPS

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
'argocd-apps/apps/grafana.yaml'

  - Entries created in:
'/api/v1/applications'
