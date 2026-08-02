module "splunk_search_head" {
    source = "./modules/Launch-Template"

    name                                 = var.name
    image_id                             = var.image_id
    instance_type                        = var.instance_type
    key_name                             = var.key_name
    instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
    monitoring                           = var.monitoring
    vpc_security_group_ids               = var.vpc_security_group_ids
    root_device_name                     = var.root_device_name
    root_volume_size                     = var.root_volume_size
    tags                                 = var.tags
    iam_instance_profile                 = module.splunk_search_head_iam.instance_profile_name
    user_data                            = filebase64("${path.module}/splunk-search-head.sh")
}
module "splunk_search_head_autoscaling_group" {
    source = "./modules/Auto-Scaling-Group"

    launch_template_id      = module.splunk_search_head.id
    launch_template_version = module.splunk_search_head.latest_version

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