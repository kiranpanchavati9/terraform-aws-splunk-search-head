variable "launch_template_id" {
  description = "Launch template ID from the Launch-Template module"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version"
  type        = string
  default     = "$Latest"
}

variable "target_group_arns" {
  description = "Target group ARNs, empty until the ALB exists"
  type        = list(string)
  default     = []
}

variable "vpc_zone_identifier" {
  description = "Subnet IDs, one per AZ"
  type        = list(string)
}

variable "health_check_type" {
  description = "EC2 or ELB. Use EC2 until a target group is attached."
  type        = string
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
}

variable "health_check_grace_period" {
  description = "Seconds before health checks begin"
  type        = number
}

variable "desired_capacity" {
  description = "Number of search head cluster members, must be odd"
  type        = number
}

variable "heartbeat_timeout" {
  description = "Seconds the termination hook waits for splunk offline"
  type        = number
}