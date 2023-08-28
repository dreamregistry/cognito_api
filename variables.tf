variable "cognito_user_pool_id" {
  type        = string
  description = "The name of the user pool to create the app client in"
}

variable "name" {
  type        = string
  description = "The name of the resource server"
  default     = null
}

variable "scopes" {
  description = "A list of custom scopes for the resource server"
  type        = list(object({
    name        = string
    description = string
  }))
  default = []
}

variable "package_organization" {
  type        = string
  description = "The GitHub organization that hosts DReAM packages."
}

variable "create_client_package" {
  type        = bool
  description = "Whether to create a client package for the resource server."
  default     = false
}

variable "client_package_repository" {
  type        = string
  description = "The GitHub repository to create the client package in."
  default     = null
}

variable "root_url" {
  type        = string
  description = "The URL of the resource server."
  default     = null
}

variable "domain_prefix" {
  type        = string
  description = "The URL of the resource server."
  default     = null
}

variable "domain_suffix" {
  type        = string
  description = "The domain suffix used for deriving the full domain name."
}

variable "public_domain_suffix" {
  type        = string
  description = "The public domain suffix used to compute the resource server identifier."
  default = null
}
