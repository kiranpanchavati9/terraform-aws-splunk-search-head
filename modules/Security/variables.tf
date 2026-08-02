variable "security_group_name" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_ports" {
  description = "Ports open to ingress_cidrs"
  type        = list(number)
  default     = []
}

variable "ingress_cidrs" {
  description = "CIDRs allowed on ingress_ports"
  type        = list(string)
  default     = []
}

variable "ingress_ports_from_sg" {
  description = "Ports open to source_security_group_id"
  type        = list(number)
  default     = []
}

variable "source_security_group_id" {
  description = "Security group allowed on ingress_ports_from_sg"
  type        = string
  default     = null
}

variable "ingress_ports_self" {
  description = "Ports open between members of this group, for SHC replication"
  type        = list(number)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}