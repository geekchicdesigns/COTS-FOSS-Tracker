#!/usr/bin/env bash
set -e

# 1. What Argo CD knows about apps (deployed intent + health)
argocd app list -o json > output/argocd_apps.json

# 2. What upstream versions exist (informational)
helm repo update
helm search repo argo-cd -o json > output/helm_versions.json

# 3. What THIS PROGRAM declares as approved (authoritative)
yq -o=json ../argocd/values/*.yaml > output/desired_versions.json

