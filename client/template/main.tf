terraform {
  backend "s3" {}
}

locals {
  identifier = var.use_local_instance ? var.local_server_resource_id: "${identifier}"
  scopes = [
    for scope in var.scopes: "$${local.identifier}/$${scope}"
  ]
}

