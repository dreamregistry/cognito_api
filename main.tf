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
  name = var.name == null ? random_pet.client_name.id : var.name
}

data "aws_cognito_user_pool_clients" "clients" {
  user_pool_id = var.cognito_user_pool_id
}

resource "random_pet" "client_name" {}

resource "aws_cognito_resource_server" "this" {
  user_pool_id = var.cognito_user_pool_id
  identifier   = "https://${random_pet.client_name.id}.${var.public_domain_suffix}"
  name         = local.name

  dynamic "scope" {
    for_each = var.scopes
    content {
      scope_name        = scope.value.name
      scope_description = scope.value.description
    }
  }
}
