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