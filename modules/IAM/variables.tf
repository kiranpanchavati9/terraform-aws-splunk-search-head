variable "iam_instance_profile" {
  description = "Name for the IAM role and instance profile"
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
  default     = {}
}