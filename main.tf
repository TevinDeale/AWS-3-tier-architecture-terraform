terraform {
  cloud {
    organization = "ttdeale96"

    workspaces {
      name = "rocket-bank-3-tier-aws"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}