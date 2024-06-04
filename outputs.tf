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