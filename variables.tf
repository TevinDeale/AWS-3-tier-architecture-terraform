variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "enable_ipv6" {
  description = "Enable IPv6 auto generation"
  type        = bool
}

variable "vpc_tag_name" {
  description = "Tag Name = <>"
  type        = string
}

variable "subnets" {
  description = "Subnet Name and number of bits for the cidr range"
  type = list(object({
    name  = string,
    cidr  = string,
    az    = string,
    index = number
  }))
}

variable "subnet_ipv6_cidr" {
  description = "List of IPv6 CIDR blocks"
  type        = list(any)
  default     = [""]
}