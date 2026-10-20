module "infrastructure" {
  source = "./modules"

  project_name = var.project_name
  common_tags  = local.common_tags

  vpc_id             = data.terraform_remote_state.foundation.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.foundation.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.foundation.outputs.private_subnet_ids

  admin_cidr    = var.admin_cidr
  key_pair_name = var.key_pair_name
  instance_type = var.instance_type

  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity

  ansible_repo_url    = var.ansible_repo_url
  ansible_repo_branch = var.ansible_repo_branch

  alert_email            = var.alert_email
  cpu_alarm_threshold    = var.cpu_alarm_threshold
  memory_alarm_threshold = var.memory_alarm_threshold
  log_retention_days     = var.log_retention_days
}
