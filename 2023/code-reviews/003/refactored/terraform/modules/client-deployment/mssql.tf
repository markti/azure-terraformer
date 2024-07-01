data "azurerm_mssql_server" "shared" {
  resource_group_name = "rg-cr3-shared-${var.environment_name}-${var.location}"
  name                = "sql-cr3-shared-${var.environment_name}-${var.location}"
}

resource "azurerm_mssql_database" "database" {
  name                 = "${var.client_name}-db"
  server_id            = data.azurerm_mssql_server.shared.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  sku_name             = var.db_info.sku_name
  max_size_gb          = var.db_info.db_size
  storage_account_type = var.db_info.storage_account_type
}
