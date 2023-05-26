data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "terraform-audistate-anuar"
    key    = "infra/cloud.tfstate"
    region = "us-east-1"
  }
}

