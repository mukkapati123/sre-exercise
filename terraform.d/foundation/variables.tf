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

variable "vpc_cidr" {
  description = "VPC CIDR block. Subnets are carved out of this as /24s"
  type        = string
  default     = "10.0.0.0/21"
}
