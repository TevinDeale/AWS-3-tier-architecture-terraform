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
    name         = "web_to_app_http",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "app-sg",
    from_port    = 80,
    to_port      = 80,
    description  = "HTTP Traffic to servers in the APP SG"
  },
  {
    name         = "https_traffic_out_ipv4_web",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv4 traffic out allowed"
  },
  {
    name         = "https_traffic_out_ipv6_web",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = "::/0",
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv6 traffic out allowed"
  },
  #APP-SG RULES
  {
    name         = "app_to_db_pg",
    sg_id        = "app-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "db-sg",
    from_port    = 5432,
    to_port      = 5432,
    description  = "app servers out to postgresql db"
  },
  {
    name         = "https_traffic_out_ipv4",
    sg_id        = "app-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv4 traffic out allowed"
  },
  {
    name         = "https_traffic_out_ipv6",
    sg_id        = "app-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = "::/0",
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv6 traffic out allowed"
  },
  #DB-SG Rules
  {
    name         = "http_traffic_out_ipv6_db",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = "::/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 80,
    to_port      = 80,
    description  = "All HTTP IPv6 traffic out allowed"
  },
  {
    name         = "http_traffic_out_ipv4_db",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 80,
    to_port      = 80,
    description  = "All HTTP IPv4 traffic out allowed"
  },
  {
    name         = "https_traffic_out_ipv4_db",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv4 traffic out allowed"
  },
  {
    name         = "https_traffic_out_ipv6_db",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = "::/0",
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "All HTTPS IPv6 traffic out allowed"
  },
  {
    name         = "replicated_postgres",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "db-sg",
    from_port    = 5432,
    to_port      = 5432,
    description  = "Allow postgres traffic to replcated dbs"
  }
]

sg_ingress_rule = [
  #WEB-RULES
  {
    name         = "https_traffic_in_ipv4",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "HTTPS IPv4 traffic in allowed"
  },
  {
    name         = "https_traffic_in_ipv6",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = "::/0",
    source_sg_id = null,
    from_port    = 443,
    to_port      = 443,
    description  = "HTTPS IPv6 traffic in allowed"
  },
  {
    name         = "https_traffic_in_on_3000",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = "0.0.0.0/0",
    source_ipv6  = null,
    source_sg_id = null,
    from_port    = 3000,
    to_port      = 3000,
    description  = "HTTPS traffic in allowed on port 3000 to reach proxy"
  },
  {
    name         = "ssh_from_sas_to_web",
    sg_id        = "web-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 22,
    to_port      = 22,
    description  = "Allow SSH from SAS SG"
  },
  {
    name         = "icmp_from_sas_to_web",
    sg_id        = "web-sg",
    ip_proto     = "icmp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 8,
    to_port      = 0,
    description  = "Allow ICMP from SAS SG"
  },
  #APP-RULES
  {
    name         = "ssh_from_sas_to_app",
    sg_id        = "app-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 22,
    to_port      = 22,
    description  = "Allow SSH from SAS SG"
  },
  {
    name         = "http_from_web",
    sg_id        = "app-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "web-sg",
    from_port    = 80,
    to_port      = 80,
    description  = "Allow http traffic from web server sg"
  },
  {
    name         = "icmp_from_sas_to_app",
    sg_id        = "app-sg",
    ip_proto     = "icmp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 8,
    to_port      = 0,
    description  = "Allow ICMP from SAS SG"
  },
  #DB-RULES
  {
    name         = "ssh_from_sas_to_db",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 22,
    to_port      = 22,
    description  = "Allow SSH from SAS SG"
  },
  {
    name         = "postgres_from_app",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "app-sg",
    from_port    = 5432,
    to_port      = 5432,
    description  = "Allow db connection from web server sg"
  },
  {
    name         = "postgres_replication",
    sg_id        = "db-sg",
    ip_proto     = "tcp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "db-sg",
    from_port    = 5432,
    to_port      = 5432,
    description  = "Allow db connection from db sg"
  },
  {
    name         = "icmp_from_sas_to_db",
    sg_id        = "db-sg",
    ip_proto     = "icmp",
    source_ipv4  = null,
    source_ipv6  = null,
    source_sg_id = "sas-sg",
    from_port    = 8,
    to_port      = 0,
    description  = "Allow ICMP from SAS SG"
  }
]


