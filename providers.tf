terraform {
  required_version = "0.12.12"

  backend "s3" {
    region = "eu-west-1"
    key    = "services/create-global-admin/service"
  }
}

provider "aws" {
  region = "eu-west-1"
}
