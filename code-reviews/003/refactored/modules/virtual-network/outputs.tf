
output "app_subnet_id" {
  value       = azurerm_subnet.app_subnet.id
  description = "Application Subnet"
}
