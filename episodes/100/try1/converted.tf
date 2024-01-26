variable "existingVNETName" {
  description = "Name of the existing VNET to inject Cloud Shell into."
}

variable "relayNamespaceName" {
  description = "Name of Azure Relay Namespace."
}

variable "nsgName" {
  description = "Name of Network Security Group."
}

variable "azureContainerInstanceOID" {
  description = "Object Id of Azure Container Instance Service Principal. We have to grant this permission to create hybrid connections in the Azure Relay you specify. To get it: Get-AzADServicePrincipal -DisplayNameBeginsWith 'Azure Container Instance'"
}

variable "containerSubnetName" {
  default     = "cloudshellsubnet"
  description = "Name of the subnet to use for cloud shell containers."
}

variable "containerSubnetAddressPrefix" {
  description = "Address space of the subnet to add for cloud shell. e.g. 10.0.1.0/26"
}

variable "relaySubnetName" {
  default     = "relaysubnet"
  description = "Name of the subnet to use for private link of relay namespace."
}

variable "relaySubnetAddressPrefix" {
  description = "Address space of the subnet to add for relay. e.g. 10.0.2.0/26"
}

variable "storageSubnetName" {
  default     = "storagesubnet"
  description = "Name of the subnet to use for storage account."
}

variable "storageSubnetAddressPrefix" {
  description = "Address space of the subnet to add for storage. e.g. 10.0.3.0/26"
}

variable "privateEndpointName" {
  default     = "cloudshellRelayEndpoint"
  description = "Name of Private Endpoint for Azure Relay."
}

variable "tagName" {
  default = {
    Environment = "cloudshell"
  }
  description = "Name of the resource tag."
}

variable "location" {
  default = azurerm_resource_group.example.location
}

resource "azurerm_subnet" "container" {
  name                 = var.containerSubnetName
  resource_group_name  = var.existingVNETName
  virtual_network_name = var.existingVNETName
  address_prefixes     = [var.containerSubnetAddressPrefix]

  delegation {
    name = "CloudShellDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_network_security_group" "example" {
  name     = var.nsgName
  location = var.location

  security_rule {
    name                       = "DenyIntraSubnetTraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.containerSubnetAddressPrefix
    destination_address_prefix = var.containerSubnetAddressPrefix
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.container.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_profile" "example" {
  name                = "aci-networkProfile-${var.location}"
  location            = var.location
  resource_group_name = var.existingVNETName
  container_network_interface {
    name = "eth-${var.containerSubnetName}"
    ip_configuration {
      name      = "ipconfig-${var.containerSubnetName}"
      subnet_id = azurerm_subnet.container.id
    }
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_network_profile.example.id
  role_definition_name = "Network Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_relay_namespace" "example" {
  name                = var.relayNamespaceName
  location            = var.location
  resource_group_name = var.existingVNETName
  sku                 = "Standard"
}

resource "azurerm_role_assignment" "relay" {
  scope                = azurerm_relay_namespace.example.id
  role_definition_name = "Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_subnet" "relay" {
  name                 = var.relaySubnetName
  resource_group_name  = var.existingVNETName
  virtual_network_name = var.existingVNETName
  address_prefixes     = [var.relaySubnetAddressPrefix]

  private_endpoint_network_policies     = "Disabled"
  private_link_service_network_policies = "Enabled"
}

resource "azurerm_private_endpoint" "example" {
  name                = var.privateEndpointName
  location            = var.location
  resource_group_name = var.existingVNETName
  subnet_id           = azurerm_subnet.relay.id

  private_service_connection {
    name                           = var.privateEndpointName
    private_connection_resource_id = azurerm_relay_namespace.example.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }
}

resource "azurerm_subnet" "storage" {
  name                 = var.storageSubnetName
  resource_group_name  = var.existingVNETName
  virtual_network_name = var.existingVNETName
  address_prefixes     = [var.storageSubnetAddressPrefix]

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.existingVNETName
}

resource "azurerm_private_dns_a_record" "example" {
  name                = var.relayNamespaceName
  zone_name           = azurerm_private_dns_zone.example.name
  resource_group_name = var.existingVNETName
  ttl                 = 3600
  records             = [azurerm_private_endpoint.example.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = var.relayNamespaceName
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.existingVNETName
  registration_enabled  = false
}

output "vnetId" {
  value = azurerm_subnet.container.virtual_network_name
}

output "containerSubnetId" {
  value = azurerm_subnet.container.id
}

output "storageSubnetId" {
  value = azurerm_subnet.storage.id
}

output "networkSecurityGroupResourceId" {
  value = azurerm_network_security_group.example.id
}

output "nsgDefaultRules" {
  value = azurerm_network_security_group.example.default_security_rule
}
