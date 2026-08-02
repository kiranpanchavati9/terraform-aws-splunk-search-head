module "splunk_search_head" {
    source = "./modules/Launch-Template"
    image_id = "ami-0220d79f3f480ecf5"
    instance_type = "t3.small"
    key_name = "aws-helpag"
    instance_initiated_shutdown_behavior = "terminate"
    monitoring = true
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    vpc_security_group_ids = ["sg-02d2ebc3b9af4f158"]
    user_data = filebase64("${path.module}/splunk-search-head.sh")
}