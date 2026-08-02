module "splunk_search_head" {
    source = "./modules/Launch-Template"
    image_id = "ami-0220d79f3f480ecf5"
    instance_type = "t3.small"
    key_name = "aws-helpag"
    instance_initiated_shutdown_behavior = "terminate"
    monitoring = true
    vpc_security_group_ids = ["sg-02d2ebc3b9af4f158"]
    user_data = filebase64("${path.module}/splunk-search-head.sh")
}