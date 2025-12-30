#!/usr/bin/env bash

set -e

argocd app list -o json > tracker/output/argocd_apps.json

helm repo update
helm search repo argo-cd -o json > tracker/output/helm_versions.json

