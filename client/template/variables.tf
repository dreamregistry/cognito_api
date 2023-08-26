variable "scopes" {
  description = "The scopes of the api to be granted to this client"
  type        = list(string)
  default = []
}
