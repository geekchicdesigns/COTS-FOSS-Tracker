### COTS / FOSS Version & Compliance Tracker
## Overview

This repository implements a GitOps-aligned COTS/FOSS tracking and compliance reporting system.
It continuously observes deployed software versions, compares them against approved baselines, and publishes authoritative compliance evidence to Confluence and Grafana.

The system is read-only to production environments, fully automated, and designed for auditability.

## Architecture (High-Level)
    WSL2 (Dev Host)
      |
      |-- KIND (Kubernetes)
      |     └─ Argo CD (Kubernetes-native, deployment source of truth)
      |
      |-- Docker Compose
      |     ├─ GitLab CE (CI/CD + source control)
      |     ├─ GitLab Runner (pipeline execution)
      |     └─ Grafana (visual compliance & runtime evidence)
      |
      └─ Confluence Cloud
            └─ Compliance records, approvals, audit trail

## Component Responsibilities
Argo CD (Kubernetes-native, running in KIND)
  - Source of truth for what is deployed
  - Maintains application health, sync status, and deployed revisions
  - Pulls configuration from GitLab (GitOps model)
  - Never receives pushes from CI

GitLab + GitLab Runner (Docker Compose)
  - Hosts this repository
  - Executes CI pipelines
  - Reads deployment state from Argo CD read-only
  - Generates compliance artifacts
  - Publishes reports to Confluence

Grafana (Docker Compose)
  - Displays runtime and version data visually
  - Serves as operational and historical evidence
  - Linked from Confluence for deeper inspection

Confluence Cloud
  - Authoritative compliance record
  - Displays:
    - Approved software registry
    - Approval status
    - Evidence links (GitLab + Grafana)
  - Designed for auditors, ISSMs, and reviewers

## Data Flow (Authoritative Direction)
GitLab Repository
     ↓ (pull)
Argo CD (deploys declared state)
     ↓ (read-only API)
GitLab CI (scan & compare)
     ↓
Confluence (compliance record)
     ↓
Grafana (visual evidence)

Key Principle
  - GitLab CI oberves -- it does not deploy.
  - ArgoCD deploys -- it does not report.

## Pipeline Stages
1. Scan Stage (scan_versions)
  - GitLab CI authenticates to Argo CD using a read-only token
  - Queries Argo CD API for all applications
  - Captures deployed revisions, health, and sync status
  - Stores results as pipeline artifacts

2. Publish Stage (publish_child_report)
  - Compares deployed versions to approved baselines
  - Generates structured JSON and Markdown reports
  - Updates Confluence page properties and content
  - Links GitLab job and Grafana dashboards as evidence

## Repository Structure
```
.
├── .gitlab-ci.yml            # CI pipeline (scan + publish)
├── argocd-apps/
│   ├── README.md
│   └── apps/                 # Argo CD Application manifests
├── docker-compose.yml        # GitLab, Runner, Grafana stack
├── env/                      # Service configuration
├── grafana/
│   ├── dashboards/
│   └── datasources/
├── tracker/
│   ├── fetch_versions.sh     # (optional) CLI-based fetch logic
│   ├── compare_versions.sh   # Compare deployed vs approved
│   ├── create_child_report.sh
│   ├── publish-to-confluence.sh
│   ├── update_confluence_page.sh
│   └── output/               # Generated artifacts
└── README.md
```

# Security & Access Model
  - ArgoCD access from CI is read-only
  - GitLab CI does not hold cluster credentials
  - No inbound connections to Kubernetes (KIND) from GitLab
  - Tokens are stored as masked CI variables
  - All actions are logged and traceable

## Compliance & Audit Intent
This system supports complaince frameworks such as:
  - NIST RMF (CM-2, CM-8, CA-7)
  - ISO/IEC 27001 (A.8, A.12, A.18)
  - Software Supply Chain transparency requirements

Evidence Source
  - GitLab pipeline logs, artifacts, job URLs
  - ArgoCD: declared vs deployed state
  - Grafana: runtime and historical data
  - Confluence: approval records and decision history

## Operating Assumptions
  - ArgoCD is Kubernetes-native (KIND) - not containerized with GitLab
  - GitLab and Grafana run via Docker Compose (App Stack)
  - Grafana visualizes
  - Confluence records compliance

The result is a simple, auditable, and scalable COTS/FOSS tracking solution suitable for regulated environments.
