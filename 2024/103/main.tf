module "regions" {
  source                   = "Azure/regions/azurerm"
  version                  = "0.7.0"
  use_cached_data          = true
  recommended_regions_only = false
}
