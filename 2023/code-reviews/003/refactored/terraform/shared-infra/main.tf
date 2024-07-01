
locals {
  supported_regions = [
    {
      address_space = "10.11"
      location      = "northcentralus"
    },
    {
      address_space = "10.12"
      location      = "westus"
    },
    {
      address_space = "10.13"
      location      = "eastus"
    }
  ]
}

module "main" {

  count = length(local.supported_regions)

  source           = "../modules/shared-infra-regional"
  application_name = var.application_name
  environment_name = var.environment_name
  address_space    = local.supported_regions[count.index].address_space
  location         = local.supported_regions[count.index].location
  location_index   = count.index

}
