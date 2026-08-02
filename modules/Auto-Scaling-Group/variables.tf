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