variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "AWS account the provider is pinned to, as a guard against applying to the wrong account"
  type        = string
}

variable "project_name" {
  description = "Project name, used as the prefix for all resource names"
  type        = string
  default     = "sre-exercise"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "exercise"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "SandeepMukkapati"
}

variable "github_org" {
  description = "GitHub account that owns the repository allowed to assume the role"
  type        = string
  default     = "mukkapati123"
}

variable "github_repo" {
  description = "Repository allowed to assume the role"
  type        = string
  default     = "sre-exercise"
}

variable "state_bucket" {
  description = "S3 bucket holding Terraform state. Created outside this configuration"
  type        = string
  default     = "sre-exercise-tf-state"
}
