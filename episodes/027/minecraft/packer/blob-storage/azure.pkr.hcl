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
      var.primary_location
    ]

  }

  communicator                      = "ssh"
  os_type                           = "Linux"

  shared_image_gallery {
    subscription   = var.subscription_id
    resource_group = var.gallery_resource_group
    gallery_name   = var.gallery_name
    image_name     = "ubuntu2004-baseline"
    image_version  = "2023.03.1"
  }

  vm_size                           = var.vm_size

  allowed_inbound_ip_addresses      = [var.agent_ipaddress]

}