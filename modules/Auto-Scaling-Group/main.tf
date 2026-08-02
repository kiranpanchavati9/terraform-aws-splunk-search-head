resource "aws_autoscaling_group" "search_head" {
  name_prefix         = "search-head-"
  vpc_zone_identifier = var.vpc_zone_identifier

  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  target_group_arns = var.target_group_arns

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 133
  }

  initial_lifecycle_hook {
    name                 = "search-head-graceful-offline"
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.heartbeat_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }

  tag {
    key                 = "Name"
    value               = "splunk-search-head"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}