output "metric_alarms" {
  value = [
    {
      type = "target-group"

      name                = "HighRequestCountPerTarget"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "RequestCountPerTarget"
      namespace           = "AWS/ApplicationELB"
      period              = "60"
      statistic           = "Sum"
      threshold           = "1000"
      alarm_description   = "Triggers a scale up of containers when the TargetGroup has a high number of requests per target"
      actions             = jsonencode([aws_appautoscaling_policy.scale_up.arn])
    },
    {
      type = "target-group"

      name                = "LowRequestCountPerTarget"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "RequestCountPerTarget"
      namespace           = "AWS/ApplicationELB"
      period              = "60"
      statistic           = "Sum"
      threshold           = "1000"
      alarm_description   = "Triggers a scale down of containers when the TargetGroup has a low number of requests per target"
      actions             = jsonencode([aws_appautoscaling_policy.scale_down.arn])
    }
  ]
}
