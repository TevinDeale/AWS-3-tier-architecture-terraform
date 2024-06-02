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

variable "igw_name" {
  description = "Name of Internet Gateway"
  type        = string
}

variable "eigw_name" {
  description = "Name of Egress Only Internet Gateway"
  type        = string
}

variable "public_rt_name" {
  description = "Public route table name"
  type        = string
}

variable "private_rt_name" {
  description = "Private route table name"
  type        = string
}

variable "public_subnet_names" {
  description = "List of subnet names that belong to the public route table"
  type        = list(string)
}

variable "private_subnet_names" {
  description = "List of subnet names that belong to the private route table"
  type        = list(string)
}