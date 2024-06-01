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