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

#IGW
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.igw_name
  }
}

#EOIGW
resource "aws_egress_only_internet_gateway" "main_eoigw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.eigw_name
  }
}

#Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = var.public_rt_name
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main_eoigw.id
  }

  tags = {
    Name = var.private_rt_name
  }
}

locals {
  subnet_name_to_id = { for subnet in aws_subnet.main_subnet : subnet.tags["Name"] => subnet.id }
}

#Route Table Associations
resource "aws_route_table_association" "pub_rt_assc" {
  for_each = toset(var.public_subnet_names)

  subnet_id      = lookup(local.subnet_name_to_id, each.value)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pvt_rt_assc" {
  for_each = toset(var.private_subnet_names)

  subnet_id      = lookup(local.subnet_name_to_id, each.value)
  route_table_id = ws_route_table.private_rt.id
}