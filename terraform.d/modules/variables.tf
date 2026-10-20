variable "project_name" {
  description = "Project name, used as the prefix for all resource names"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to instances launched by the Auto Scaling group, which do not inherit provider default_tags"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC the resources are created in"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets, used by the load balancer and the bastion"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets, used by the web tier"
  type        = list(string)
}

variable "admin_cidr" {
  description = "Operator address allowed to SSH to the bastion, as a /32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && endswith(var.admin_cidr, "/32")
    error_message = "admin_cidr must be a single host address in /32 form, for example 203.0.113.42/32."
  }
}

variable "key_pair_name" {
  description = "Existing EC2 key pair used for SSH. Created outside this configuration."
  type        = string
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
