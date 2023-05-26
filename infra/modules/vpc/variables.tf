variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "cidr_block" {
  type        = string
  description = "CIDR BLOCK"
}

variable "public_subnets" {
}

variable "private_subnets" {
}

variable "availability_zones" {
}