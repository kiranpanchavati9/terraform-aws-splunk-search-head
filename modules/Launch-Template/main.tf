resource "aws_launch_template" "splunk-search-head" {
  name = "splunk-search-head"

  iam_instance_profile {
    name = "SplunkSearchHead"
  }
  image_id = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type = var.instance_type
  key_name = var.key_name

  monitoring {
    enabled = var.monitoring
  }

  placement {
    availability_zone = random_shuffle.availability_zones.result[0]
  }
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data = var.user_data
}

resource "random_shuffle" "availability_zones" {
  input = var.availability_zones
  result_count = 1
}