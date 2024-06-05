variable "security_groups" {
  description = "List of security groups"

  type = list(object({
    name        = string
    description = string
  }))
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
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

/* SG RULE TEMPLATE. REPLACE NULL VALUES
  {
    name         = null,
    sg_id        = null,
    ip_proto     = null,
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = null,
    to_port      = null,
    description  = null
  }
  */