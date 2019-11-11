resource "aws_cloudwatch_metric_alarm" "healthy_hosts" {
  alarm_name          = "${local.fqsn}-healthy-hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "Healthy Hosts"
  alarm_actions       = [module.admin-sns-email-topic.arn]

  insufficient_data_actions = []
  tags                      = var.tags

  dimensions = {
    TargetGroup  = aws_alb_target_group.app.arn_suffix
    LoadBalancer = data.aws_lb.ingress.arn_suffix
  }
}


module "admin-sns-email-topic" {
  source = "github.com/deanwilson/tf_sns_email"

  display_name    = "${local.fqsn} Notifications"
  email_address   = var.email_to_alert
  owner           = local.fqsn
  stack_name      = "${local.fqsn}-sns-email"
  additional_tags = var.tags
}
