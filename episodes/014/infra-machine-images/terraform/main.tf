resource azurerm_resource_group main {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}

locals {
  gallery_name = replace("gal${var.application_name}${var.environment_name}", "-", "")
}

resource azurerm_shared_image_gallery main {
  name                = local.gallery_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "Shared images and things."

}

resource azurerm_shared_image ubuntu1804_baseline {
  name                = "ubuntu1804-baseline"
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"

  identifier {
    publisher = "AzureTerraformer"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS-Baseline"
  }
}

resource azurerm_shared_image windows2016_baseline {
  name                = "windows2016-baseline"
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"

  identifier {
    publisher = "AzureTerraformer"
    offer     = "WindowsServer"
    sku       = "Windows2016-DataCenter"
  }
}