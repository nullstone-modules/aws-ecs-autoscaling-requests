variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "scale_down_threshold" {
  default = 10
  type = number
  description = "The autoscaling policy will cause a scale down when the average number of requests per container per minute drops below this amount."
}

variable "scale_up_threshold" {
  default     = 100
  type        = number
  description = "The autoscaling policy will cause a scale up when the average number of requests per container per minute exceeds this amount."
}

variable "scale_cooldown" {
  default     = 60
  type        = number
  description = "The amount of time to wait before a consecutive scale up/down alarm can trigger a scale up/down."
}

variable "min_capacity" {
  default     = 1
  type        = number
  description = "The minimum number of containers to keep running."
}

variable "max_capacity" {
  default     = 10
  type        = number
  description = "The maximum number of containers that are able to run before stopping scale up policies."
}
