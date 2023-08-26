terraform {
  backend "s3" {}
}

provider "aws" {}

locals {
  scopes = [
    for scope in var.scopes: "${identifier}/$${scope}"
  ]
}

