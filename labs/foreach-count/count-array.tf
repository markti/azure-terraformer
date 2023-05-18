
locals {
  region_count_array = [
    {
      location      = "westus"
      address_space = "2.0/23"
    },
    {
      location      = "westus2"
      address_space = "4.0/23"
    },
    {
      location      = "eastus"
      address_space = "6.0/23"
    },
    {
      location      = "eastus2"
      address_space = "8.0/23"
    },
    {
      location      = "southcentralus"
      address_space = "10.0/23"
    },
    {
      location      = "westcentralus"
      address_space = "12.0/23"
    },
    {
      location      = "westus3"
      address_space = "14.0/23"
    }
  ]
}

resource "azurerm_virtual_hub" "regions" {

  for_each = local.regional_hub_map

  name                = "vhub-${var.application_name}-${var.environment_name}-${each.key}"
  resource_group_name = azurerm_resource_group.main.name
  location            = each.key
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = "${var.wan_address_space_prefix}.${each.value}"

}
