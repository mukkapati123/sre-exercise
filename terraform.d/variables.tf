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

variable "state_bucket" {
  description = "S3 bucket holding Terraform state, read here to pick up the foundation outputs"
  type        = string
  default     = "sre-exercise-tf-state"
}

variable "admin_cidr" {
  description = "Operator address allowed to SSH to the bastion, as a /32"
  type        = string
}

variable "key_pair_name" {
  description = "Existing EC2 key pair used for SSH. Created outside this configuration."
  type        = string
  default     = "sre-exercise-key-pair"
}

variable "instance_type" {
  description = "Instance type for the bastion and the web tier"
  type        = string
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "Minimum web instances"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum web instances"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Web instances to run when there is no scaling pressure"
  type        = number
  default     = 1
}

variable "ansible_repo_url" {
  description = "Repository ansible-pull clones at boot to configure the web tier"
  type        = string
  default     = "https://github.com/mukkapati123/sre-exercise.git"
}

variable "ansible_repo_branch" {
  description = "Branch ansible-pull checks out"
  type        = string
  default     = "main"
}

variable "alert_email" {
  description = "Address subscribed to the alarm topic. AWS sends a confirmation mail that must be accepted before anything is delivered."
  type        = string
}

variable "cpu_alarm_threshold" {
  description = "CPU percentage that raises the high CPU alarm and drives target tracking"
  type        = number
  default     = 70
}

variable "memory_alarm_threshold" {
  description = "Memory percentage that raises the high memory alarm"
  type        = number
  default     = 80
}

variable "log_retention_days" {
  description = "Retention on the log groups. Without it CloudWatch keeps logs forever and the bill creeps."
  type        = number
  default     = 7
}
