resource "aws_cloudwatch_log_group" "auth" {
  name              = "/${var.project_name}/secure"
  retention_in_days = var.log_retention_days
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

locals {
  alarms = {
    cpu_high = {
      description = "Average CPU across the web tier is above the threshold"
      namespace   = "AWS/EC2"
      metric_name = "CPUUtilization"
      threshold   = var.cpu_alarm_threshold
    }
    memory_high = {
      description = "Average memory across the web tier is above the threshold"
      namespace   = "CWAgent"
      metric_name = "mem_used_percent"
      threshold   = var.memory_alarm_threshold
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "web" {
  for_each = local.alarms

  alarm_name          = "${var.project_name}-${replace(each.key, "_", "-")}"
  alarm_description   = each.value.description
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  threshold           = each.value.threshold
  comparison_operator = "GreaterThanThreshold"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  treat_missing_data = "notBreaching"
}
