module "splunk_search_head" {
  source = "./modules/Launch-Template"

  name                                 = var.name
  image_id                             = var.image_id
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  monitoring                           = var.monitoring
  vpc_security_group_ids               = [module.search_head_security_group.security_group_id]
  root_device_name                     = var.root_device_name
  root_volume_size                     = var.root_volume_size
  tags                                 = var.tags
  iam_instance_profile                 = module.splunk_search_head_iam.instance_profile_name
  user_data                            = filebase64("${path.module}/splunk-search-head.sh")
  splunk_device_name                   = var.splunk_device_name
  splunk_volume_size                   = var.splunk_volume_size
  iops                                 = var.iops
  throughput                           = var.throughput
}
module "splunk_search_head_autoscaling_group" {
  source = "./modules/Auto-Scaling-Group"

  launch_template_id      = module.splunk_search_head.id
  launch_template_version = module.splunk_search_head.latest_version
  target_group_arns       = [module.splunk_search_head_alb.target_group_arn]

  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_type         = var.health_check_type
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  desired_capacity          = var.desired_capacity
  heartbeat_timeout         = var.heartbeat_timeout
}

module "splunk_search_head_iam" {
  source = "./modules/IAM"

  iam_instance_profile = var.iam_instance_profile
  tags                 = var.tags
}

data "aws_subnet" "check" {
  for_each = toset(var.vpc_zone_identifier)
  id       = each.value
}

output "subnet_azs" {
  value = { for k, v in data.aws_subnet.check : k => v.availability_zone }
}


module "alb_security_group" {
  source = "./modules/Security"

  security_group_name        = "splunk-alb-sg"
  security_group_description = "Splunk search head ALB"
  vpc_id                     = var.vpc_id
  ingress_ports              = [80]
  ingress_cidrs              = var.allowed_cidrs
  tags                       = var.tags
}

module "search_head_security_group" {
  source = "./modules/Security"

  security_group_name        = "splunk-search-head-sg"
  security_group_description = "Splunk search heads"
  vpc_id                     = var.vpc_id

  ingress_ports = [22, 8089]
  ingress_cidrs = var.admin_cidrs

  ingress_ports_from_sg    = [8000]
  source_security_group_id = module.alb_security_group.security_group_id

  ingress_ports_self = [8191, 9887, 8089]

  tags = var.tags
}

module "splunk_search_head_alb" {
  source = "./modules/Application-Load-Balancer"

  name              = var.name
  vpc_id            = var.vpc_id
  subnet_ids        = var.vpc_zone_identifier
  security_group_id = module.alb_security_group.security_group_id
  tags              = var.tags
}