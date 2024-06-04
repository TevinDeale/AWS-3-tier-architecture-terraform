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

variable "igw_name" {
  description = "Name of internet gateway"
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

variable "security_groups" {
  description = "List of security groups"

  type = list(object({
    name        = string
    description = string
  }))
}

variable "sg_egress_rule" {
  description = "SECURITY GROUP EGRESS RULES"
  type = list(object({
    name         = string
    sg_id        = string
    ip_proto     = string
    from_port    = number
    to_port      = number
    source_ipv4  = string
    source_ipv6  = string
    source_sg_id = string
    description  = string
  }))

  default = null
}