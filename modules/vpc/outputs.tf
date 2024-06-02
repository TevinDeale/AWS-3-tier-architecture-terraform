output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "vpc_ipv6_cidr" {
  value = aws_vpc.main_vpc.ipv6_cidr_block
}

output "subnets" {
  description = "Subnet Details"
  value = [
    for subnet in aws_subnet.main_subnet : {
      name            = subnet.tags["Name"]
      cidr_block      = subnet.cidr_block
      ipv6_cidr_block = subnet.ipv6_cidr_block
      AZ              = subnet.availability_zone
      ID              = subnet.id
    }
  ]
}