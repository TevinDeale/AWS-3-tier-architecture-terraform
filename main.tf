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
  #VPC
  source       = "./modules/vpc"
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