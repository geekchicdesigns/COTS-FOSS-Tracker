## Tooling container inside GitLab Runner

### ArgoCD via CI
  - GitLab job runs in a container
  - Container installs `argocd`
  - Container talkes to ArgoCD via:
    - LoadBalancer
    - Ingress
    - or port-forward via kubectl

GitLab CI container
   ├─ installs argocd CLI
   ├─ port-forwards Argo CD API
   ├─ authenticates with token
   └─ reads Argo CD state (read-only)

ArgoCD itself:
  - stays Kubernetes-native (KIND)
  - stays outside docker-compose (App Stack - WSL2)
  - remain the deployment authority

### TODO: ArgoCD via dedicated admin pod in Kubernetes
```
kubectl run argocd-admin \
  -n argocd \
  --rm -it \
  --image=alpine \
  -- sh
```

  - Inside pod:
```
apk add curl bash
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
argocd login argocd-server.argocd.svc.cluster.local --auth-token $TOKEN
```

### Local Sanity Check
`kubectl get svc -n argocd`

SUCCESSFUL OUTPUT: `argocd-server`
