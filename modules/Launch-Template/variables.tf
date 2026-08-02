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

variable "vpc_security_group_ids" {
  description = "Security group IDs to attach"
  type        = list(string)
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