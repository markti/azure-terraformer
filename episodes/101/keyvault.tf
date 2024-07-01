
module "keyvault" {
  source              = "markti/azure-terraformer/azurerm//modules/keyvault/simple"
  version             = "1.0.17"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = random_string.main.result
}