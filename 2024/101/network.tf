
module "network" {
  source              = "markti/azure-terraformer/azurerm//modules/network/simple"
  version             = "1.0.17"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = random_string.main.result
  address_space       = "10.0.20.0/22"
}