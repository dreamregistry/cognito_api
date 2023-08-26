terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {}

locals {
  scopes = [
    for scope in var.scopes: "$${data.aws_cognito_resource_server.server.identifier}/$${scope}"
  ]
}

data "aws_cognito_resource_server" "server" {
  user_pool_id = "${userPoolId}"
  identifier   = "${identifier}"
}

