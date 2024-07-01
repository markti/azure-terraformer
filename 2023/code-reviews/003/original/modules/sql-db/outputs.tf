output "database_url" {
  value       = "${data.azurerm_mssql_server.shared-sql-server.name}.database.windows.net:1433;database=${data.azurerm_mssql_server.shared-sql-server.name};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
  description = "The Azure SQL server URL."
}
