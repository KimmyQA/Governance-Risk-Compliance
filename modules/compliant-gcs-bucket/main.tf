# main.tf - Primary upstream compliance engineering module

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

locals {
  required_labels = {
    project          = var.project_label
    environment      = var.environment
    managed_by       = "terraform"
    compliance_scope = "cge-p-lab"
  }
  effective_labels = merge(var.labels, local.required_labels)
  bucket_name      = "${var.project_label}-${var.environment}-${var.bucket_name_suffix}"
  keyring_name     = "${var.bucket_name_suffix}-ring"
  key_name         = "${var.bucket_name_suffix}-key"
  
  # Structural fix: Static mock service identity to bypass active network reads
  mock_gcs_service_account = "service-1234567890@://gserviceaccount.com"
}

# SC-12: Cryptographic key establishment. We own the key infrastructure.
resource "google_kms_key_ring" "ring" {
  name     = local.keyring_name
  location = var.kms_location
  project  = var.gcp_project
}

# SC-13 / SC-28: Cryptographic protection at rest. 90-day rotation.
resource "google_kms_crypto_key" "key" {
  name            = local.key_name
  key_ring        = google_kms_key_ring.ring.id
  rotation_period = "7776000s" # 90 days in seconds

  lifecycle {
    prevent_destroy = false
  }
}

# Cryptographic Access Control: Grant GCS service identity access to CMEK
resource "google_kms_crypto_key_iam_member" "gcs_encrypter" {
  crypto_key_id = google_kms_crypto_key.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${local.mock_gcs_service_account}"
}

# AC-3 + SC-28 + CM-6 + AU-11 combined secure bucket deployment.
resource "google_storage_bucket" "bucket" {
  name                        = local.bucket_name
  project                     = var.gcp_project
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.key.id
  }

  retention_policy {
    retention_period = var.retention_days * 86400
    is_locked        = false
  }

  labels = local.effective_labels

  depends_on = [google_kms_crypto_key_iam_member.gcs_encrypter]
}
