variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "enable_ipv6" {
  description = "Enable IPV6 auto generation"
  type        = bool
}

variable "vpc_tag_name" {
  description = "Tag Name = <>"
  type        = string
}

variable "subnet_ipv6_cidr" {
  description = "List ofvsubnet IPv6 CIDR Range"
  type        = list(string)
  default     = [""]
}

variable "subnets" {
  description = "Subnet information"
  type = list(object({
    name  = string,
    cidr  = string,
    az    = string,
    index = number
  }))
}