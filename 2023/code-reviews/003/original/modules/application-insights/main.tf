
resource "azurerm_application_insights" "application_insights" {
  name                = "${var.client_name}-appinsights"
  location            = var.location
  resource_group_name = var.resource_group
  application_type    = "other"
}
