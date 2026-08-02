variable "image_id" {
  description = "Image ID to use for the launch template"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the launch template"
  type        = string
}

variable "key_name" {
  description = "Key name to use for the launch template"
  type        = string
}

variable "instance_initiated_shutdown_behavior" {
  description = "Instance initiated shutdown behavior to use for the launch template"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones to use for the launch template"
  type        = list(string)
}

variable "monitoring" {
  description = "Monitoring to use for the launch template"
  type        = bool
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs to use for the launch template"
  type        = list(string)
}

variable "user_data" {
  description = "User data to use for the launch template"
  type        = string
}

