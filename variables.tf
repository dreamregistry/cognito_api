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

variable "public_domain_suffix" {
  type        = string
  description = "The public domain suffix used to compute the resource server identifier."
}

