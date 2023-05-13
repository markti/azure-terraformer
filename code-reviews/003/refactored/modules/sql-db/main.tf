

# This rule only allows traffic from the apps VNet
resource "azurerm_mssql_virtual_network_rule" "network_rule" {
  name      = "${var.client_name}-rule"
  server_id = var.sqlserver_id
  subnet_id = var.subnet_id
}

resource "azurerm_mssql_database" "database" {
  name                 = "${var.client_name}-db"
  server_id            = var.sqlserver_id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  sku_name             = var.db_info.sku_name
  max_size_gb          = var.db_info.db_size
  storage_account_type = var.db_info.storage_account_type


}

