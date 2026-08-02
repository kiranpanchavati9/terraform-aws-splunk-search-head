name                                 = "splunk-search-head"
image_id                             = "ami-0220d79f3f480ecf5"
instance_type                        = "m5.large"
key_name                             = "aws-helpag"
instance_initiated_shutdown_behavior = "stop"
monitoring                           = true
user_data                            = ""
iam_instance_profile                 = "SplunkSearchHead"
root_device_name                     = "/dev/xvda"
root_volume_size                     = 100
launch_template_name                 = "splunk-search-head-launch-template"

vpc_id = "vpc-0fcbf944165ec4597"

vpc_zone_identifier = [
  "subnet-02b2facb986b86601",
  "subnet-004e12cfcbc98b621",
  "subnet-0e9272cbed90dc89c",
]

allowed_cidrs = ["0.0.0.0/0"]
admin_cidrs   = ["0.0.0.0/0"]

health_check_type         = "EC2"
health_check_grace_period = 900
min_size                  = 0
max_size                  = 3
desired_capacity          = 3
heartbeat_timeout         = 600
iops                      = 6000
throughput                = 250
splunk_device_name        = "/dev/xvdb"
splunk_volume_size        = 100

tags = {
  Role        = "search-head"
  Environment = "dev"
}