output "OIDC_SCOPES_${repository}" {
  description = "OIDC scopes granted to the client"
  value       = join(" ", local.scopes)
}


output "${repository}_URL" {
  value = var.use_local_instance ? var.local_server_url : "${serverUrl}"
}
