variable application_name {
  type    = string
  default = "myapp"
}
variable environment_name {
  type    = string
  default = "dev"
}
variable location {
  type    = string
  default = "West US"
}

resource azurerm_resource_group main {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}
