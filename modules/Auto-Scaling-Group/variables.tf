variable "vpc_zone_identifier" {
  description = "The VPC zone identifier"
  type        = list(string)
  default     = ["subnet-02b2facb986b86601","subnet-004e12cfcbc98b621", "subnet-0c846e5406c9d6146","subnet-0e9272cbed90dc89c","subnet-047d70c4f2b77bbf1","subnet-05ff6038d2dcf648e"]
}

variable "health_check_type" {
  description = "The health check type"
  type        = string
  default     = "ELB"
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 3
}

variable "health_check_grace_period" {
  description = "The health check grace period"
  type        = number
  default     = 300
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  type        = number
  default     = 4
}

variable "heartbeat_timeout" {
  description = "The heartbeat timeout of the autoscaling group"
  type        = number
  default     = 2000
}

variable "launch_template_name" {
  description = "The name of the launch template"
  type        = string
  default     = "search-head-launch-template"
}