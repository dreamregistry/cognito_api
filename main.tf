terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "aws" {}
provider "github" {
  owner = var.package_organization
}

locals {
  name = var.name == null ? random_pet.client_name.id : var.name
  root_url = var.root_url != null ? var.root_url: "https://${var.domain_prefix}.${var.domain_suffix}"
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

module "client" {
  source                    = "./client"
  count                     = var.create_client_package ? 1 : 0
  cognito_user_pool_id      = var.cognito_user_pool_id
  resource_identifier       = aws_cognito_resource_server.this.identifier
  root_url                  = local.root_url
  client_package_repository = var.client_package_repository
}