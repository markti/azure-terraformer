
resource random_string main { 
  length  = 8 
  upper   = false 
  special = false
}

locals {
  name = "ep10"
}

resource azurerm_resource_group main {
  name     = "rg-${local.name}-${random_string.main.result}"
  location = var.location
}

output rando {
  value = random_string.main.result
}
output rg_id {
  value = azurerm_resource_group.main.id
}

data azurerm_resource_group existing {
  name = "rg-ep2-mr8x8gxj"
}

output rg2_id {
  value = data.azurerm_resource_group.existing.id
}