variable "client_package_repository" {
  type        = string
  description = "The GitHub repository to create the client package in."
}

variable "cognito_user_pool_id" {
  type        = string
  description = "The name of the user pool to create the app client in"
}

variable "resource_identifier" {
  type        = string
  description = "The identifier for the resource server"
}

variable "root_url" {
  type        = string
  description = "The URL of the resource server."
}
