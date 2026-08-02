variable "name" {
  description = "Name prefix for the launch template and instances"
  type        = string
}

variable "image_id" {
  description = "AMI ID for the search head"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_initiated_shutdown_behavior" {
  description = "Behaviour on in-guest shutdown: stop or terminate"
  type        = string
}

variable "monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
}


variable "user_data" {
  description = "Base64-encoded user data script"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
}

variable "root_device_name" {
  description = "Root device name, /dev/xvda on Amazon Linux, /dev/sda1 on RHEL"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

variable "tags" {
  description = "Tags applied to instances and volumes"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB, security groups, and search heads"
  type        = string
}

variable "allowed_cidrs" {
  description = "CIDRs allowed to reach the ALB listener"
  type        = list(string)
}

variable "admin_cidrs" {
  description = "CIDRs allowed for admin access to search heads (SSH/management)"
  type        = list(string)
}

## Auto-Scaling Group Variables

variable "vpc_zone_identifier" {
  description = "The VPC zone identifier"
  type        = list(string)
}

variable "health_check_type" {
  description = "The health check type"
  type        = string
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number

}

variable "health_check_grace_period" {
  description = "The health check grace period"
  type        = number
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  type        = number
}

variable "heartbeat_timeout" {
  description = "The heartbeat timeout of the autoscaling group"
  type        = number
}

variable "launch_template_name" {
  description = "The name of the launch template"
  type        = string
}

variable "splunk_device_name" {
  description = "Splunk device name, /dev/xvdb on Amazon Linux, /dev/sdb1 on RHEL"
  type        = string
}

variable "splunk_volume_size" {
  description = "Splunk volume size in GB"
  type        = number
}

variable "iops" {
  description = "IOPS for the splunk volume"
  type        = number
}

variable "throughput" {
  description = "Throughput for the splunk volume"
  type        = number
}