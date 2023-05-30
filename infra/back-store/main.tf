terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = "~> 4.40"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Genera un nombre aleatorio para el bucket
resource "random_pet" "bucket_name" {
  length = 2
  separator = "-"
}

# Crea el bucket de S3 con el nombre único

resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = random_pet.bucket_name.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = random_pet.bucket_name.id

    versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = random_pet.bucket_name.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform-locks-db" {
    name =  "terraform-audilocks-anuar1"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}