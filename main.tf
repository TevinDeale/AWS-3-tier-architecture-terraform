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
  sg_ingress_rule = var.sg_ingress_rule
  sg_egress_rule  = var.sg_egress_rule
}

module "instance" {
  source = "./modules/ec2"

  #Security Groups
  security_groups = module.sg

  #rb-sas-use-1a
  instances = var.instances
}