output "application_url" {
  value       = "https://${azurerm_windows_web_app.application.default_hostname}"
  description = "The Web application URL."
}

output "application_fqdn" {
  value       = azurerm_windows_web_app.application.default_hostname
  description = "The Web application fully qualified domain name (FQDN)."
}

