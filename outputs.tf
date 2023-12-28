output "metric_alarms" {
  value = [
    {
      type = "target-group"

      name                = "HighRequestCountPerTarget"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "RequestCountPerTarget"
      namespace           = "AWS/ApplicationELB"
      period              = var.scale_up_period
      statistic           = "Average"
      threshold           = var.scale_up_threshold
      alarm_description   = "Triggers a scale up of containers when the TargetGroup has a high number of requests per target"
      actions             = jsonencode([aws_appautoscaling_policy.scale_up.arn])
    },
    {
      type = "target-group"

      name                = "LowRequestCountPerTarget"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "RequestCountPerTarget"
      namespace           = "AWS/ApplicationELB"
      period              = var.scale_down_period
      statistic           = "Average"
      threshold           = var.scale_down_threshold
      alarm_description   = "Triggers a scale down of containers when the TargetGroup has a low number of requests per target"
      actions             = jsonencode([aws_appautoscaling_policy.scale_down.arn])
    }
  ]
}
