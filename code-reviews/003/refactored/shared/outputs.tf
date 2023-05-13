output "app_service_plan_id" {
  value       = azurerm_service_plan.service-plan.id
  description = "Service Plan ID"
}

output "sqlserver_id" {
  value = azurerm_mssql_server.shared-sql.id
}

output "vnet_id" {
  value = azurerm_virtual_network.virtual_network.id

}

output "db_username" {
  value = azurerm_mssql_server.shared-sql.administrator_login
}
output "db_password" {
  value     = azurerm_mssql_server.shared-sql.administrator_login_password
  sensitive = true
}
