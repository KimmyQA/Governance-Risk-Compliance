# variables.tf - Input configuration and compliance validation rules

variable "gcp_project" {
  type        = string
  description = "The target Google Cloud project ID."
}

variable "project_label" {
  type        = string
  description = "Project component string utilized in name mapping and labels."
}

variable "environment" {
  type        = string
  description = "The target stage. Generally 'dev' or 'prod'."
}

variable "bucket_name_suffix" {
  type        = string
  description = "Unique text appended to standard namespace generation."
}

variable "location" {
  type        = string
  default     = "us-central1"
  description = "The geographical location for the bucket storage (supports upper/lowercase names)."
}

variable "kms_location" {
  type        = string
  default     = "us-central1"
  description = "The strict location for the KMS infrastructure (requires specific lowercase names)."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Optional custom labels supplied by the system consumer."
}

variable "retention_days" {
  type        = number
  description = "The data holding duration expressed in integer days."

  # --- THE COMPLIANCE GUARDRAIL ---
  # This block evaluates business configuration before compilation.
  validation {
    condition = (
      var.environment != "prod" || var.retention_days >= 365
    )
    error_message = "\n\nvar.environment is \"prod\"\nvar.retention_days is Less than 365.\nretention_days must be >= 365 when environment == \"prod\" to satisfy control AU-11.\n"
  }
}
