
data "azurerm_service_plan" "main" {
  resource_group_name = "rg-cr3-shared-${var.environment_name}-${var.location}"
  name                = "asp-cr3-shared-${var.environment_name}-${var.location}"
}

data "azurerm_application_insights" "main" {
  resource_group_name = "rg-cr3-shared-${var.environment_name}-${var.location}"
  name                = "appi-cr3-shared-${var.environment_name}-${var.location}"
}

data "azurerm_key_vault" "main" {
  resource_group_name = "rg-cr3-shared-${var.environment_name}-${var.location}"
  name                = "kv-cr3-shared-${var.environment_name}-${var.location_index}"
}

resource "azurerm_windows_web_app" "main" {
  name                = "app-${var.application_name}-${var.environment_name}-${var.client_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = data.azurerm_service_plan.main.id
  https_only          = true

  site_config {
    always_on  = true
    ftps_state = "FtpsOnly"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    // Monitoring with Azure Application Insights
    "APPINSIGHTS_INSTRUMENTATIONKEY" = data.azurerm_application_insights.main.instrumentation_key

    # These are app specific environment variables

    "DATABASE_URL"      = data.azurerm_mssql_server.shared.fully_qualified_domain_name
    "DATABASE_USERNAME" = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.main.name};SecretName=database-username)"
    "DATABASE_PASSWORD" = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.main.name};SecretName=database-password)"

    "AZURE_STORAGE_ACCOUNT_NAME"  = data.azurerm_storage_account.shared.name
    "AZURE_STORAGE_BLOB_ENDPOINT" = data.azurerm_storage_account.shared.primary_blob_endpoint
    "AZURE_STORAGE_ACCOUNT_KEY"   = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.main.name};SecretName=storage-key)"
  }
}

resource "azurerm_key_vault_access_policy" "client_app" {

  key_vault_id = data.azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_windows_web_app.main.identity[0].principal_id

  secret_permissions = [
    "Get"
  ]
}
