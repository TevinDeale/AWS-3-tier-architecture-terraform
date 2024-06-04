terraform {
  cloud {
    organization = "RocketBank"

    workspaces {
      name = "rocket-bank-3-tier-aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  #VPC
  vpc_cidr     = var.vpc_cidr
  enable_ipv6  = var.enable_ipv6
  vpc_tag_name = var.vpc_tag_name

  #Subnet
  subnets = var.subnets
  subnet_ipv6_cidr = cidrsubnets(
    module.vpc.vpc_ipv6_cidr,
    8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
  )

  #IGW
  igw_name = var.igw_name

  #EOIGW
  eigw_name = var.eigw_name

  #Route Tables
  public_rt_name  = var.public_rt_name
  private_rt_name = var.private_rt_name

  #Route Table Associations
  public_subnet_names  = var.public_subnet_names
  private_subnet_names = var.private_subnet_names
}

module "sg" {
  source = "./modules/sg"

  #SG
  security_groups = var.security_groups
  vpc_id          = module.vpc.vpc_id

  #SG EGRESS RULES
  sg_egress_rule = [
    {
      name         = "all_traffic_out_ipv4",
      sg_id        = "sas-sg",
      ip_proto     = "-1"
      source_ipv4  = "0.0.0.0/0"
      description  = "All IPv4 traffic out allowed"
      from_port    = null
      to_port      = null
      source_ipv6  = null
      source_sg_id = null
    },
    {
      name         = "all_traffic_out_ipv6",
      sg_id        = "sas-sg",
      ip_proto     = "-1"
      source_ipv4  = null
      description  = "All IPv6 traffic out allowed"
      from_port    = null
      to_port      = null
      source_ipv6  = "::/0"
      source_sg_id = null
    }
  ]
}