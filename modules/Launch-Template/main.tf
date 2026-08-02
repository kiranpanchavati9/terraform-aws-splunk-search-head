resource "aws_launch_template" "splunk_search_head" {
  name_prefix = "${var.name}-"

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  vpc_security_group_ids               = var.vpc_security_group_ids
  user_data                            = var.user_data

  monitoring {
    enabled = var.monitoring
  }

  block_device_mappings {
    device_name = var.root_device_name

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  block_device_mappings {
    device_name = var.splunk_device_name

    ebs {
      volume_size           = var.splunk_volume_size
      volume_type           = "gp3"
      iops                  = var.iops
      throughput            = var.throughput
      encrypted             = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = var.name })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(var.tags, { Name = "${var.name}-root" })
  }

  lifecycle {
    create_before_destroy = true
  }
}