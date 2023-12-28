# Requests Autoscaling for ECS/Fargate

This creates an auto-scaling configuration for ECS/Fargate apps that scales in/out based on load balancer requests.

## Configuration

This capability provides configuration for `scale_up_threshold` and `scale_down_threshold`.
- A scale up event occurs when the average number of requests against each container in `scale_up_period` exceeds `scale_up_threshold`.
- A scale down event occurs when the average number of requests against each container in `scale_down_period` drops below `scale_down_threshold`.

The `scale_cooldown` is used to prevent rapid scale in/out.
No auto-scaling events will happen until after `scale_cooldown` from another scaling event.
