# consumers/dev/main.tf - Development deployment calling our compliant module

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "your-gcp-project" # Placeholder: substitute your real project ID later
  region  = "us-central1"
}

module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  # Six lines of simple business configuration
  gcp_project        = "your-gcp-project" # Placeholder: substitute your real project ID later
  project_label      = "cgep-lab"
  environment        = "dev"
  retention_days     = 30
  bucket_name_suffix = "dev-data-001"
  
  # Dual-location configuration parameters
  location     = "us-central1"
  kms_location = "us-central1"
}

output "attestation" {
  value       = module.data_bucket.compliance_attestation
  description = "The structured JSON payload required for downstream Rego assertions and OSCAL evidence pipelines."
}

output "bucket_url" {
  value       = module.data_bucket.bucket_url
  description = "The target storage bucket locator string."
}
