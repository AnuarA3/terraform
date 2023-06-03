terraform {
  required_version = "1.4.6"
}

provider "aws" {
  region     = var.aws_region
}


terraform {
  backend "s3" {
    bucket = "famous-moose"
    key    = "infra/resources/cloud.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-audilocks-anuar1"
    encrypt = true

  }
}

module "resources" {
    source = "../modules"

    app_name = var.app_name
    app_environment = var.app_environment
    aws_region = var.aws_region
  }