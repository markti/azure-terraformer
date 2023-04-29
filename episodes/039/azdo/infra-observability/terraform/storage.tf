
locals {
  storage_region_array = split(",", var.storage_regions)
}

resource random_string storage_name_suffix {
  
  count = length(local.storage_region_array)

  length           = 8
  upper            = false
  special          = false

}

resource azurerm_storage_account main {

  count = length(local.storage_region_array)

  name                     = "staztf${random_string.storage_name_suffix[count.index].result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = trim(local.storage_region_array[count.index], " ")
  account_tier             = "Standard"
  account_replication_type = "GRS"

}