
locals {

  region_count_map = {
    westus         = "2.0/23",
    westus2        = "4.0/23",
    eastus         = "6.0/23",
    eastus2        = "8.0/23",
    southcentralus = "10.0/23",
    westcentralus  = "12.0/23",
    westus3        = "14.0/23"
  }
}

resource "azurerm_virtual_hub" "regions" {

  for_each = local.regional_hub_map

  name                = "vhub-${var.application_name}-${var.environment_name}-${each.key}"
  resource_group_name = azurerm_resource_group.main.name
  location            = each.key
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = "${var.wan_address_space_prefix}.${each.value}"

}
