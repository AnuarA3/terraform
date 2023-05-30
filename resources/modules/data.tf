data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "assured-toad"
    key    = "infra/cloud.tfstate"
    region = "us-east-1"
  }
}

