output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_ipv6_cidr" {
  description = "VPC IPV6 CIDR BLOCK"
  value       = module.vpc.vpc_ipv6_cidr
}

output "subnets" {
  description = "SUBNET DETAILS"
  value       = module.vpc.subnets
}

output "public_subnets" {
  description = "LIST OF PUBLIC SUBNET NAMES"
  value       = var.public_subnet_names
}

output "private_subnets" {
  description = "LIST OF PRIVATE SUBNET NAMES"
  value       = var.private_subnet_names
}

output "security_groups" {
  description = "SECURITY GROUP DETAILS"
  value       = module.sg.security_groups
}

output "instances" {
  description = "EC2 INSTANCES DETAILS"
  value = [
    for instance in module.instance.instances : {
      name         = instance.tags["Name"],
      arn          = instance.arn
      id           = instance.id
      ipv6_address = instance.ipv6_addresses
      ipv4_private = instance.private_ip
      ipv4_public  = instance.public_ip
      az           = instance.availability_zone
      subnet       = lookup({ for sn in module.vpc.subnets : sn.ID => sn.name }, instance.subnet_id)
      sg           = instance.security_groups
    }
  ]
}

output "instance_private_ips" {
  description = "EC2 INSTANCE PRIVATE IPV4 ADDRESSES"
  value       = [for instance in module.instance.instances : instance.private_ip]
}