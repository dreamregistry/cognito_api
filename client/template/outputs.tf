output "OIDC_SCOPES_${repository}" {
  description = "OIDC scopes granted to the client"
  value       = join(" ", var.scopes)
}


output "${repository}_URL" {
  value = "${serverUrl}"
}
