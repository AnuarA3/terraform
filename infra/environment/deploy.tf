terraform {
  required_version = "1.4.6"
}

provider "aws" {
  region     = var.aws_region
}


terraform {
  backend "s3" {
    bucket         = "famous-moose"
    key            = "infra/cloud.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-audilocks-anuar1"
    encrypt        = true
  }
}


module "vpc" {
  source = "../modules/vpc"

  app_name = var.app_name
  app_environment = var.app_environment
  aws_region = var.aws_region
  cidr_block = "10.10.0.0/16"
  public_subnets = ["10.10.0.0/24","10.10.1.0/24"]
  private_subnets = ["10.10.2.0/24","10.10.3.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  }

output "private_subnets" {
  value = module.vpc.private_subnets_id
}

output "public_subnets" {
  value = module.vpc.public_subnets_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_cidr_block" {
  value = module.vpc.private_cidr_block
}
