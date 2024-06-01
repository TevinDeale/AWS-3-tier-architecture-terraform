#VPC
resource "aws_vpc" "main_vpc" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  instance_tenancy                 = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_tag_name
  }
}

#Subnets
resource "aws_subnet" "main_subnet" {
  for_each = { for subnet in var.subnets : subnet.name => {
    name  = subnet.name
    cidr  = subnet.cidr
    az    = subnet.az
    index = subnet.index
  } }

  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = each.value.cidr
  ipv6_cidr_block = element(
  var.subnet_ipv6_cidr, each.value.index)
  assign_ipv6_address_on_creation = true
  availability_zone               = each.value.az

  tags = {
    Name = each.value.name
  }
}


#Route Tables

#Route Table Associations


#IGW


#EOIGW