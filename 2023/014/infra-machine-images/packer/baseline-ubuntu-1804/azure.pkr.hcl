source azure-arm vm {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  location                          = var.primary_location
  managed_image_name                = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.gallery_resource_group

  shared_image_gallery_destination {
    subscription        = var.subscription_id
    resource_group      = var.gallery_resource_group
    gallery_name        = var.gallery_name
    image_name          = var.image_name
    image_version       = var.image_version
    replication_regions = [
      var.primary_location,
      "East US"
    ]

  }

  communicator                      = "ssh"
  os_type                           = "Linux"
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18.04-LTS"

  vm_size                           = "Standard_DS2_v2"

  allowed_inbound_ip_addresses      = [var.agent_ipaddress]

}