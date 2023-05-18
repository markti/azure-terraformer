locals {
  regions_array = [
    "West US", 
    "West US 2", 
    "West US 3"
  ]
}

module minecarft_blob_storage_server {

  count = length(local.regions_array)
  
  source = "../modules/minecraft/blob-storage-backend"

  location               = local.regions_array[count.index]
  resource_group_name    = azurerm_resource_group.main.name
  name                   = "minecraftblob${count.index}"
  gallery_name           = var.gallery_name
  gallery_resource_group = var.gallery_resource_group
  image_name             = var.minecraft_blob_image_name
  image_version          = var.minecraft_blob_image_version
  subnet_id              = module.network[count.index].subnet_id
  ssh_public_key         = tls_private_key.main.public_key_openssh

}

module minecarft_local_storage_server {

  count = length(local.regions_array)
  
  source = "../modules/minecraft/local-storage-backend"

  location               = local.regions_array[count.index]
  resource_group_name    = azurerm_resource_group.main.name
  name                   = "minecraftlocal${count.index}"
  gallery_name           = var.gallery_name
  gallery_resource_group = var.gallery_resource_group
  image_name             = var.minecraft_local_image_name
  image_version          = var.minecraft_local_image_version
  subnet_id              = module.network[count.index].subnet_id
  ssh_public_key         = tls_private_key.main.public_key_openssh

}