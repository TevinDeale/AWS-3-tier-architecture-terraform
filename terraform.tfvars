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

