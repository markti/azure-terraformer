output "app_service_plan_id" {
  value       = azurerm_service_plan.main.id
  description = "Service Plan ID"
}
output "sqlserver_id" {
  value = azurerm_mssql_server.main.id
}
output "vnet_id" {
  value = azurerm_virtual_network.main.id

}
output "db_username" {
  value = azurerm_mssql_server.main.administrator_login
}
output "db_password" {
  value     = azurerm_mssql_server.main.administrator_login_password
  sensitive = true
}