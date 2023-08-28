variable "scopes" {
  description = "The scopes of the api to be granted to this client"
  type        = list(string)
  default     = []
}

variable "use_local_instance" {
  description = "Whether to use the local instance of the api (typically for development) or not"
  type        = bool
  default     = false
}

variable "local_server_url" {
  description = "The url of the local instance of the api"
  type        = string
  default     = "http://localhost:4000"
}
