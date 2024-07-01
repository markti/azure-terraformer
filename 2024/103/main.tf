module "regions" {
  source          = "Azure/regions/azurerm"
  version         = "0.6.0"
  use_cached_data = false
}

locals {
  matches = [
    for v in module.regions.regions_by_geography_group["US"] : v
  ]
  with_azs = [for v in local.matches : v.name if v.zones != null]
  no_azs   = [for v in local.matches : v.name if v.zones == null]
}

resource "random_shuffle" "us_region" {
  input        = [for v in local.matches : v.name]
  result_count = 1
}