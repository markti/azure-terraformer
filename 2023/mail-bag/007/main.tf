
data azurerm_resources resource {
  name = var.resource_name
}

locals {
  subscription_id = split( "/", data.azurerm_resources.resource.resources[0].id)[2]
  resource_group_name = split( "/", data.azurerm_resources.resource.resources[0].id)[4]
}
