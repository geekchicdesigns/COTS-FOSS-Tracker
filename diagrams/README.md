### RMF / Compliance Control Mapping (inline)

This table shows how controls are satisfied by design, not by policy statements.

| Control Framework | Control ID                        | How This System Satisfies It                                           |
| ----------------- | --------------------------------- | ---------------------------------------------------------------------- |
| **NIST RMF**      | CM-2 (Baseline Configuration)     | Approved versions are declared in Git; Argo CD enforces declared state |
| **NIST RMF**      | CM-8 (System Component Inventory) | Argo CD API provides authoritative inventory of deployed apps          |
| **NIST RMF**      | CA-7 (Continuous Monitoring)      | GitLab CI periodically scans Argo CD state and records results         |
| **NIST RMF**      | AU-3 (Audit Logging)              | GitLab job logs, artifacts, and timestamps are immutable               |
| **NIST RMF**      | IA-5 (Authenticator Management)   | CI uses read-only Argo CD tokens stored as masked variables            |
| **ISO 27001**     | A.8.9 (Configuration Management)  | GitOps ensures declared vs deployed configuration traceability         |
| **ISO 27001**     | A.12.1 (Change Management)        | All changes originate as Git commits with review history               |
| **ISO 27001**     | A.12.4 (Logging & Monitoring)     | CI logs + Grafana dashboards provide operational evidence              |
| **ISO 27001**     | A.18.1 (Compliance)               | Confluence acts as the authoritative compliance record                 |

Important:
Controls are met through architecture and automation, not manual enforcement.

### How Auditors Use This System

This section explains the system from an auditor’s point of view.

## Starting Point: Confluence
Auditors begin in Confluence Cloud, not in tooling.

Each software component (e.g., OpenSSL, Terraform, ArgoCD) has a page containing:
  - Approved Version
  - Approval Status (Approved / Pending / Rejected)
  - Approval Authority
  - Approval Date
  - CI Evidence link
  - Grafana Evidence link
These value are populated automatically by GitLab CI.

## Verifying Evidence (No Access Required)
Auditors do not need access to:
  - Kubernetes (KIND)
  - GitLab Runner
  - ArgoCD
  - Grafana internals
They can: 
  - Click the CI Evidence link -> GitLab job
  - View immutable logs and artifacts
  - Confirm timestamps and pipeline IDs

## Cross-Checking Deployed State
If deeper validation is required:
  - CI artifacts show exact ArgoCD application state
  - ArgoCD is the authoritative deployment source
  - No manual edits are possible without Git history
This eliminates "configuration drift" arguments.

## Runtime Confirmation (Optional)
Grafana dashboard provide:
  - Version visibility over time
  - Runtime confirmation of deployed components
  - Historical data retention
Grafana is supporting evidence, not the system of record.

## Approval & Accountability
Approvals are expressed as:
  - Declarative metadata in Confluence
  - Linked to CI evidence
  - Linked to Git history
There is no history approved state.

### Compliance Posture Summary
| Question Auditors Ask  | Where Answer Is Found     |
| ---------------------- | ------------------------- |
| What is deployed?      | Argo CD (via CI artifact) |
| What is approved?      | Git + Confluence          |
| Who approved it?       | Confluence metadata       |
| When was it verified?  | GitLab pipeline timestamp |
| Is evidence immutable? | GitLab artifacts          |
| Is runtime visible?    | Grafana                   |

## Design Principles
  - Design Principles (Why This Holds Up in Reviews)

Single Source of Truth: Git + Argo CD
  - Read-Only CI: No deployment authority
  - Immutable Evidence: Pipeline artifacts
  - Human-Readable Compliance: Confluence
  - No Tool Sprawl: Each component has one job

## Final Note for Reviewers
This system is intentionally simple:
  - No custom approval engines
  - No bidirectional integrations
  - No hidden state
  - No manual synchronization

It is designed to be:
  - Explainable in minutes
  - Auditable without privileged access
  - Sustainable in regulated environments

