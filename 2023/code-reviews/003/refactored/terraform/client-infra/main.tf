locals {
  clients = [
    {
      name           = "client1"
      location       = "northcentralus"
      location_index = "0"
    },
    {
      name           = "client2"
      location       = "northcentralus"
      location_index = "0"
    },
    {
      name           = "client3"
      location       = "westus"
      location_index = "1"
    },
    {
      name           = "client4"
      location       = "eastus"
      location_index = "2"
    }
  ]
}

module "client_deployment" {

  count = length(local.clients)

  source           = "../modules/client-deployment"
  application_name = var.application_name
  environment_name = var.environment_name
  client_name      = local.clients[count.index].name
  location         = local.clients[count.index].location
  location_index   = local.clients[count.index].location_index
  db_info = {
    sku_name             = "Basic"
    db_size              = 1
    geo_backup_enabled   = false
    storage_account_type = "Local"
  }
}