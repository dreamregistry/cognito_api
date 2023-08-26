terraform {
  backend "s3" {}
}

locals {
  scopes = [
    for scope in var.scopes: "${identifier}/$${scope}"
  ]
}

