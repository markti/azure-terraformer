output id {
  value = data.azurerm_resources.resources.resources[0].id
}
output resource_group_name {
  value = local.resource_group_name
}