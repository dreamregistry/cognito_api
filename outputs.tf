output "COGNITO_CLIENT_IDS" {
  description = "Comma separated list of Cognito Client IDs"
  value       = join(",", data.aws_cognito_user_pool_clients.clients.client_ids)
}

output "COGNITO_RESOURCE_SERVER_IDENTIFIER" {
  description = "Cognito Resource Server Identifier to be used as prefix for scopes"
  value       = aws_cognito_resource_server.this.identifier
}

output "USER_POOL_ID" {
  description = "Cognito User Pool ID"
  value       = var.cognito_user_pool_id
}
