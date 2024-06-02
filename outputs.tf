output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_ipv6_cidr" {
  value = module.vpc.vpc_ipv6_cidr
}

output "subnets" {
  description = "Subnet Details"
  value       = module.vpc.subnets
}

output "public_subnets" {
  description = "List of public subnets"
  value       = var.public_subnet_names
}

output "private_subnets" {
  description = "List of private subnets"
  value       = var.private_subnet_names
}