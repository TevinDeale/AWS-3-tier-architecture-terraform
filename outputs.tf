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

output "main_instances" {
  description = "EC2 INSTANCES DETAILS"
  value       = module.instance.fmt_instances
}

output "instance_private_ips" {
  description = "EC2 INSTANCE PRIVATE IPV4 ADDRESSES"
  value       = [for instance in module.instance.instances : instance.private_ip]
}

output "tgs" {
  description = "TARGET GROUPS"
  value       = module.elb.tgs
}

output "elb" {
  description = "LOAD BALANCER DETAILS"
  value       = module.elb.elb
}