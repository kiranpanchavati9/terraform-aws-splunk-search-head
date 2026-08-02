resource "aws_placement_group" "search-head-placement-group" {
  name     = "search-head-placement-group"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "search-head-autoscaling-group" {
  name                      = "search-head-autoscaling-group"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = true
  placement_group           = aws_placement_group.search-head-placement-group.id
  launch_configuration      = aws_launch_configuration.search-head-launch-configuration.name
  vpc_zone_identifier       = var.vpc_zone_identifier

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  initial_lifecycle_hook {
    name                 = "search-head-initial-lifecycle-hook"
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.heartbeat_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = jsonencode({
      search-head = "search-head"
    })
  }
}