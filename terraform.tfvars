vpc_cidr     = "192.168.30.0/24"
enable_ipv6  = true
vpc_tag_name = "Rocket-Bank-PROD"

subnets = [
  {
    name  = "rocket-bank-use-1a-sas",
    cidr  = "192.168.30.0/28",
    az    = "us-east-1a",
    index = 0
  },
  {
    name  = "rocket-bank-use-1a-web",
    cidr  = "192.168.30.16/28",
    az    = "us-east-1a",
    index = 1,
  },
  {
    name  = "rocket-bank-use-1a-app",
    cidr  = "192.168.30.32/28",
    az    = "us-east-1a",
    index = 2
  },
  {
    name  = "rocket-bank-use-1a-db",
    cidr  = "192.168.30.48/28",
    az    = "us-east-1a",
    index = 3
  },
  {
    name  = "rocket-bank-use-1b-web",
    cidr  = "192.168.30.64/28",
    az    = "us-east-1b",
    index = 4
  },
  {
    name  = "rocket-bank-use-1b-app",
    cidr  = "192.168.30.80/28",
    az    = "us-east-1b",
    index = 5
  },
  {
    name  = "rocket-bank-use-1b-db",
    cidr  = "192.168.30.96/28",
    az    = "us-east-1b",
    index = 6
  },
  {
    name  = "rocket-bank-use-1c-web",
    cidr  = "192.168.30.112/28",
    az    = "us-east-1c",
    index = 7
  },
  {
    name  = "rocket-bank-use-1c-app",
    cidr  = "192.168.30.128/28",
    az    = "us-east-1c",
    index = 8
  },
  {
    name  = "rocket-bank-use-1c-db",
    cidr  = "192.168.30.144/28",
    az    = "us-east-1c",
    index = 9
  }
]

igw_name  = "rocket-bank-use-igw"
eigw_name = "rocket-bank-use-eigw"

public_rt_name  = "rocket-bank-use-pub-rt"
private_rt_name = "rocket-bank-use-pvt-rt"

public_subnet_names = ["rocket-bank-use-1a-web", "rocket-bank-use-1b-web", "rocket-bank-use-1c-web"]

private_subnet_names = [
  "rocket-bank-use-1a-sas",
  "rocket-bank-use-1a-app",
  "rocket-bank-use-1a-db",
  "rocket-bank-use-1b-app",
  "rocket-bank-use-1b-db",
  "rocket-bank-use-1c-app",
  "rocket-bank-use-1c-db"
]

security_groups = [
  {
    name        = "sas-sg",
    description = "SAS security group"
  },
  {
    name        = "web-sg",
    description = "Web security group"
  },
  {
    name        = "app-sg",
    description = "App security group"
  },
  {
    name        = "db-sg",
    description = "Database security group"
  },
]

sg_egress_rule = [
  #SAS-SG RULES
  {
    name         = "all_traffic_out_ipv4",
    sg_id        = "sas-sg",
    ip_proto     = "-1",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = null,
    to_port      = null,
    description  = "All IPv4 traffic out allowed"
  },
  {
    name         = "all_traffic_out_ipv6",
    sg_id        = "sas-sg",
    ip_proto     = "-1",
    source_ipv4  = null,
    source_ipv6  = "::/0",
    source_sg_id = null,
    from_port    = null,
    to_port      = null,
    description  = "All IPv6 traffic out allowed"
  },
  #WEB-SG RULES
  {
    name         = null,
    sg_id        = null,
    ip_proto     = null,
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = null,
    to_port      = null,
    description  = null
  }
]