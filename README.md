# COTS-FOSS-Tracker
Tracking Infrastructure COTS/FOSS Versioning

## COTS/FOSS Tracker - Local Automation
What the tracker does (locally)
1. Pull live versions from:
   - Argo CD apps
   - Helm charts
   - Container registries
2. Compare against:
   - Approved baseline
   - Last known good
3. Output:
   - `versions.json` (machine)
   - `versions.md` (manual)

## Core Idea
    - Everything runs in Docker Compose (Single Stack)
    - GitLab = Repo hosting, CI pipelines, approvals
    - Argo CD = GitOps + version tracker (Source of truth for deployed versions)
    - Confluence = authoritative documentation (COTS/FOSS register, approvals, audit trail)
    - Grafana = visibility & reporting
    - Postgres = Shard DB for GitLab & Confluence

## Best-Practice Flow
    - Keep results in Git first, Conflunence second
    - Treat Confluence as published state, not source of truth
    - Use GitLab approvals, not Confluence-only approvals
    - Grafana = read-only visibility, never decision authority
    - Later: swap  Docker Compose -> Kind -> EKS with zero logic changes

## .gitlab-ci.yml
    - Runs Nightly + Manual Approval
    - Mirrors RMF-style approval flow
    - Keeps Git as source of truth
    - Prevents auto-publishing without signoff

## Confluence (Approval Workflow)
Workflow:
  1. GitLab job generates results
  2. Draft Confluence page created
  3. Approval gate in GitLab
  4. On approval -> page updated + status changed

    COTS/FOSS Component
    ────────────────────
    Name:
    Current Version:
    Approved Version:
    Source (ArgoCD / Helm / Image):
    Risk Level:
    Approval Status:
    Approval Date:
    Approved By:

## Next Steps:
  1. Add real Argo CD app manifests
  2. Finalize version comparison logic
  3. Build Grafana JSON dashboard
  4. Automate Confluence publishing
  5. Introduce SBOM / Trivy data
