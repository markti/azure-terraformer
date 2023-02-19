source "azure-arm" "vm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  location                          = "West US"
  managed_image_name                = "aztf-w2016"
  managed_image_resource_group_name = "rg-ep9-packer"

  communicator                      = "winrm"
  winrm_use_ssl                     = true
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_username                    = "packer"

  os_type                           = "Windows"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2016-Datacenter"

  vm_size                           = "Standard_DS2_v2"

  allowed_inbound_ip_addresses      = [var.my_ip_address]

}