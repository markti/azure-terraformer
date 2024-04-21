resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${random_string.main.result}"
  location = module.rando_region.result[0]
}

module "rando_region" {
  source          = "markti/azure-terraformer/azurerm//modules/region/rando"
  version         = "1.0.16"
  geography_group = "US"
}