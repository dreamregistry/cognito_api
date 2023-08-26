terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "github_repository" "client_package" {
  name        = var.client_package_repository
  description = "Client package for ${var.client_package_repository} API"
  visibility  = "public"
}

resource "github_repository_file" "client_package_files" {
  for_each   = fileset("${path.module}/template", "**")
  repository = github_repository.client_package.name
  file       = each.value
  content    = templatefile("${path.module}/template/${each.value}", {
    identifier = var.resource_identifier
    repository = upper(var.client_package_repository)
    serverUrl  = var.root_url
  })
}
