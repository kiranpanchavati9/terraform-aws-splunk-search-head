module "splunk_search_head" {
    source = "./modules/Launch-Template"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
    monitoring = true
    vpc_security_group_ids = ["sg-02d2ebc3b9af4f158"]
    user_data = filebase64("${path.module}/splunk-search-head.sh")
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