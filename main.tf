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

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_key
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

locals {
  sg_name_to_id     = { for sg in module.sg.security_groups : sg.name => sg.id }
  subnet_name_to_id = { for subnet in module.vpc.subnets : subnet.name => subnet.ID }
}

module "instance" {
  source = "./modules/ec2"

  instances = [
    #SAS-INSTANCE
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-sas-use-1a-2"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1a-sas")
      private_ip     = "192.168.30.14"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "sas-sg")]
      key            = "rb"
      volume_size    = 20
      user_data      = templatefile("${path.module}/userdata/tailscale.sh", { tailscale_key = var.tailscale_key })
    },
    #web Instances
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-web-use-1a"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1a-web")
      private_ip     = "192.168.30.23"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "web-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-web-use-1a" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-web-use-1b"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1b-web")
      private_ip     = "192.168.30.71"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "web-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-web-use-1b" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-web-use-1c"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1c-web")
      private_ip     = "192.168.30.123"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "web-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-web-use-1c" })
    },
    #APP-INSTANCES
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-app-use-1a"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1a-app")
      private_ip     = "192.168.30.42"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "app-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-app-use-1a" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-app-use-1b"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1b-app")
      private_ip     = "192.168.30.85"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "app-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-app-use-1b" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-app-use-1c"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1c-app")
      private_ip     = "192.168.30.138"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "app-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-app-use-1c" })
    },
    #DB-INSTANCES
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-db-use-1a"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1a-db")
      private_ip     = "192.168.30.55"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "db-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-db-use-1a" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-db-use-1b"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1b-db")
      private_ip     = "192.168.30.103"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "db-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-db-use-1b" })
    },
    {
      ami            = "ami-00beae93a2d981137"
      type           = "t2.micro"
      name           = "rb-db-use-1c"
      subnet_id      = lookup(local.subnet_name_to_id, "rocket-bank-use-1c-db")
      private_ip     = "192.168.30.148"
      public_ipv4    = false
      ipv6_count     = 1
      security_group = [lookup(local.sg_name_to_id, "db-sg")]
      key            = "rb"
      volume_size    = 8
      user_data      = templatefile("${path.module}/userdata/hostname.sh", { name = "rb-db-use-1c" })
    },
  ]
}

module "elb" {
  depends_on = [module.instance]
  source     = "./modules/loadbalancer"

  tg = [
    {
      name                  = "rb-web-tg",
      port                  = 443,
      protocol              = "HTTPS"
      vpc_id                = module.vpc.vpc_id
      enable_health_check   = true
      health_check_interval = 300
      health_check_path     = "/"
      enable_sticky         = true
      cookie_name           = "connect.sid"
      cookie_duration       = 3600
      sticky_type           = "app_cookie"
    },
    {
      name                  = "rb-proxy-tg",
      port                  = 3000,
      protocol              = "HTTP"
      vpc_id                = module.vpc.vpc_id
      enable_health_check   = true
      health_check_interval = 300
      health_check_path     = "/welcome"
      enable_sticky         = true
      cookie_name           = "connect.sid"
      cookie_duration       = 3600
      sticky_type           = "app_cookie"
    },
    {
      name                  = "rb-api-tg",
      port                  = 8080,
      protocol              = "TCP"
      vpc_id                = module.vpc.vpc_id
      enable_health_check   = true
      health_check_interval = 300
      health_check_path     = "/welcome"
      enable_sticky         = false
      cookie_name           = null
      cookie_duration       = null
      sticky_type           = "source_ip"
    },
    {
      name                  = "rb-db-tg",
      port                  = 5432,
      protocol              = "TCP"
      vpc_id                = module.vpc.vpc_id
      enable_health_check   = null
      health_check_interval = null
      health_check_path     = null
      enable_sticky         = false
      cookie_name           = null
      cookie_duration       = null
      sticky_type           = "source_ip"
    }
  ]

  targets = [
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-web-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-web-use-1a")
      target_port = 4173
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-web-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-web-use-1b")
      target_port = 4173
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-web-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-web-use-1c")
      target_port = 4173
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-proxy-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1a")
      target_port = 3000
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-proxy-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1b")
      target_port = 3000
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-proxy-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1c")
      target_port = 3000
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-api-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1a")
      target_port = 8080
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-api-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1b")
      target_port = 8080
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-api-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-app-use-1c")
      target_port = 8080
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-db-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-db-use-1a")
      target_port = 5432
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-db-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-db-use-1b")
      target_port = 5432
    },
    {
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-db-tg")
      target_id   = lookup({ for instance in module.instance.fmt_instances : instance.name => instance.id }, "rb-db-use-1c")
      target_port = 5432
    },
  ]

  elb = [
    {
      name     = "rb-web-proxy-alb"
      internal = false
      type     = "application"
      security_groups = [
        lookup(local.sg_name_to_id, "web-sg"),
        lookup(local.sg_name_to_id, "app-sg"),
      ]
      subnets = [
        lookup(local.subnet_name_to_id, "rocket-bank-use-1a-web"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1b-web"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1c-web"),
      ]
      phh                   = true
      xff_client_port       = true
      xff_header_processing = "preserve"
      cross_zone            = true
    },
    {
      name     = "rb-api-nlb"
      internal = true
      type     = "network"
      security_groups = [
        lookup(local.sg_name_to_id, "app-sg")
      ]
      subnets = [
        lookup(local.subnet_name_to_id, "rocket-bank-use-1a-app"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1b-app"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1c-app"),
      ]
      phh                   = true
      xff_client_port       = true
      xff_header_processing = "preserve"
      cross_zone            = true
    },
    {
      name     = "rb-db-nlb"
      internal = true
      type     = "network"
      security_groups = [
        lookup(local.sg_name_to_id, "app-sg")
      ]
      subnets = [
        lookup(local.subnet_name_to_id, "rocket-bank-use-1a-db"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1b-db"),
        lookup(local.subnet_name_to_id, "rocket-bank-use-1c-db"),
      ]
      phh                   = null
      xff_client_port       = null
      xff_header_processing = null
      cross_zone            = true
    },
  ]

  lb_listeners = [
    {
      lb_arn      = lookup({ for lb in module.elb.elb : lb.name => lb.arn }, "rb-web-proxy-alb")
      port        = 443
      protocol    = "HTTPS"
      ssl_policy  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      cert_arn    = "arn:aws:acm:us-east-1:905418375402:certificate/cea12e1b-5d67-4498-a2e4-3545ffe94163"
      action_type = "forward"
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-web-tg")
    },
    {
      lb_arn      = lookup({ for lb in module.elb.elb : lb.name => lb.arn }, "rb-web-proxy-alb")
      port        = 3000
      protocol    = "HTTPS"
      ssl_policy  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      cert_arn    = "arn:aws:acm:us-east-1:905418375402:certificate/cea12e1b-5d67-4498-a2e4-3545ffe94163"
      action_type = "forward"
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-proxy-tg")
    },
    {
      lb_arn      = lookup({ for lb in module.elb.elb : lb.name => lb.arn }, "rb-api-nlb")
      port        = 80
      protocol    = "TCP"
      ssl_policy  = null
      cert_arn    = null
      action_type = "forward"
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-api-tg")
    },
    {
      lb_arn      = lookup({ for lb in module.elb.elb : lb.name => lb.arn }, "rb-db-nlb")
      port        = 5432
      protocol    = "TCP"
      ssl_policy  = null
      cert_arn    = null
      action_type = "forward"
      tg_arn      = lookup({ for tg in module.elb.tgs : tg.name => tg.arn }, "rb-db-tg")
    }
  ]
}

resource "cloudflare_record" "rb-dns-record" {
  depends_on = [module.elb]
  zone_id    = var.tevin_d_zone_id
  name       = "rocketbank"
  value      = lookup({ for lb_dns in module.elb.elb : lb_dns.name => lb_dns.dns }, "rb-web-proxy-alb")
  type       = "CNAME"
  proxied    = false
}