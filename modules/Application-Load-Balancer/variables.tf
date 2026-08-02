variable "name" {
  description = "Name prefix for ALB resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC the target group belongs to"
  type        = string
}

variable "subnet_ids" {
  description = "At least two subnets in different AZs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for the ALB"
  type        = string
}

variable "internal" {
  description = "Internal or internet-facing"
  type        = bool
  default     = false
}

variable "listener_port" {
  description = "Port the ALB listens on"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "Port Splunk Web listens on"
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "Splunk login page, returns 200 without auth"
  type        = string
  default     = "/en-US/account/login"
}

variable "health_check_interval" {
  description = "Seconds between health checks"
  type        = number
  default     = 30
}

variable "idle_timeout" {
  description = "Seconds before idle connections drop, raised for long searches"
  type        = number
  default     = 600
}

variable "stickiness_duration" {
  description = "Session cookie lifetime, match the Splunk session timeout"
  type        = number
  default     = 28800
}

variable "deregistration_delay" {
  description = "Seconds to drain connections before removing a target"
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "Prevent accidental deletion, enable in production"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}