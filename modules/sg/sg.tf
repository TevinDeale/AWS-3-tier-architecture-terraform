#Security Group
resource "aws_security_group" "main_sg" {
  for_each = { for sg in var.security_groups : sg.name => {
    name        = sg.name
    description = sg.description
  } }

  name                   = each.value.name
  description            = each.value.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = {
    Name = each.value.name
  }
}

#Security group ingress rules
locals {
  egress_rules = var.sg_egress_rule != null ? { for rule in var.sg_egress_rule : rule.name => {
    name        = rule.name
    sg_id       = rule.sg_id
    ip_proto    = rule.ip_proto
    from_port   = rule.from_port
    to_port     = rule.to_port
    cidr_ipv4   = rule.source_ipv4
    cidr_ipv6   = rule.source_ipv6
    ref_sg_id   = rule.source_sg_id
    description = rule.description
  } } : {}

  ingress_rules = var.sg_egress_rule != null ? { for rule in var.sg_ingress_rule : rule.name => {
    name        = rule.name
    sg_id       = rule.sg_id
    ip_proto    = rule.ip_proto
    from_port   = rule.from_port
    to_port     = rule.to_port
    cidr_ipv4   = rule.source_ipv4
    cidr_ipv6   = rule.source_ipv6
    ref_sg_id   = rule.source_sg_id
    description = rule.description
  } } : {}

  sg_name_to_id = { for sg in aws_security_group.main_sg : sg.name => sg.id }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  for_each = local.ingress_rules

  security_group_id = lookup(local.sg_name_to_id, each.value.sg_id)

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.ref_sg_id != null ? lookup(local.sg_name_to_id, each.value.ref_sg_id) : null
  ip_protocol                  = each.value.ip_proto
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  description                  = each.value.description

  tags = {
    Name = each.value.name
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  for_each = local.egress_rules

  security_group_id = lookup(local.sg_name_to_id, each.value.sg_id)

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.ref_sg_id != null ? lookup(local.sg_name_to_id, each.value.ref_sg_id) : null
  ip_protocol                  = each.value.ip_proto
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  description                  = each.value.description

  tags = {
    Name = each.value.name
  }
}

