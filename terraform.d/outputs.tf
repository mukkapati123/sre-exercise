output "alb_dns_name" {
  description = "Public hostname of the load balancer"
  value       = module.infrastructure.alb_dns_name
}

output "alb_url" {
  description = "URL the smoke test calls"
  value       = module.infrastructure.alb_url
}

output "bastion_public_ip" {
  description = "SSH entry point to the private subnets"
  value       = module.infrastructure.bastion_public_ip
}

output "autoscaling_group_name" {
  description = "Name of the web Auto Scaling group"
  value       = module.infrastructure.autoscaling_group_name
}

output "target_group_arn" {
  description = "Target group the web instances register with"
  value       = module.infrastructure.target_group_arn
}

output "sns_topic_arn" {
  description = "Topic the alarms publish to"
  value       = module.infrastructure.sns_topic_arn
}
