# 🛡️ Enterprise Governance, Risk, and Compliance (GRC) Architecture

## 🚀 Automated Policy-as-Code Framework (Lab 2.4)
This repository demonstrates a complete **Shift-Left Security Pipeline** built to automate cloud compliance audits. Utilizing an advanced upstream module architecture, this framework consumes simple business inputs and automatically enforces corporate security controls before resources reach the cloud.

### 📁 Core Repository Components
* **`modules/`**: The core compliance engine defining security guardrails.
* **`consumers/`**: Deployment runtime generating verified data contracts.
* **`policy/`**: Open Policy Agent (OPA) validation rules written in Rego v1.0.

---

## 🔬 Machine-Readable Audit Evidence Mapping
The pipeline translates complex Infrastructure-as-Code metrics into a flat, deterministic JSON attestation contract. This artifact serves as the primary data injection layer for automated auditor evaluations:

```json
{
  "encryption_algorithm": "google-managed-cmek-aes256",
  "kms_rotation_period": "7776000s",
  "public_access_prevention": "enforced",
  "required_labels_present": true,
  "retention_period_days": 30,
  "uniform_access_enforced": true,
  "versioning_enabled": true
}
```

### 🔒 Enforced Security Control Baseline (NIST SP 800-53 Mappings)
* **SC-12 (Cryptographic Key Establishment)**: Mandates a strict 90-day hardware-enforced Customer-Managed Encryption Key (CMEK) rotation window (`7776000s`).
* **AC-3 (Access Enforcement)**: Enforces public access prevention parameters alongside Unified IAM Bucket Level Access to eliminate structural exposure flaws.
* **AU-11 (Audit Record Retention)**: Hardlocks multi-version object history tracking and retention hold policy thresholds to safeguard records.
* **CM-6 (Configuration Settings)**: Automatically injects and validates system metadata tags to block the creation of unmonitored shadow cloud environments.
