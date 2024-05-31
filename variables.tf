variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
}

variable "enable_ipv6" {
  description = "Enable IPv6 auto generation"
  type = bool
}

variable "vpc_tag_name" {
  description = "Tag Name = <>"
  type = string
}