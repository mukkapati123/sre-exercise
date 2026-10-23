output "alb_dns_name" {
  description = "Public hostname of the load balancer"
  value       = aws_lb.web.dns_name
}

output "alb_url" {
  description = "URL the smoke test calls"
  value       = "http://${aws_lb.web.dns_name}"
}

output "bastion_public_ip" {
  description = "SSH entry point to the private subnets"
  value       = aws_instance.bastion.public_ip
}

output "autoscaling_group_name" {
  description = "Name of the web Auto Scaling group"
  value       = aws_autoscaling_group.web.name
}

output "target_group_arn" {
  description = "Target group the web instances register with"
  value       = aws_lb_target_group.web.arn
}

output "sns_topic_arn" {
  description = "Topic the alarms publish to"
  value       = aws_sns_topic.alerts.arn
}
