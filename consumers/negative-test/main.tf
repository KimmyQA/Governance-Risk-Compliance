# consumers/negative-test/main.tf - Policy violation test module

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
  project = "your-gcp-project"
  region  = "us-central1"
}

module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  gcp_project        = "your-gcp-project"
  project_label      = "cgep-lab"
  environment        = "prod"               # Business config says PROD...
  retention_days     = 30                   # POLICY VIOLATION: Prod requires >= 365!
  bucket_name_suffix = "should-never-exist"
  
  location     = "us-central1"
  kms_location = "us-central1"
}
