provider "azurerm" {
  features {}
}

variable "existingVNETName" {
  type        = string
  description = "Name of the existing VNET to inject Cloud Shell into."
}

variable "relayNamespaceName" {
  type        = string
  description = "Name of Azure Relay Namespace."
}

variable "nsgName" {
  type        = string
  description = "Name of Network Security Group."
}

variable "azureContainerInstanceOID" {
  type        = string
  description = "Object Id of Azure Container Instance Service Principal."
}

variable "containerSubnetName" {
  type        = string
  default     = "cloudshellsubnet"
  description = "Name of the subnet to use for cloud shell containers."
}

variable "containerSubnetAddressPrefix" {
  type        = string
  description = "Address space of the subnet to add for cloud shell. e.g. 10.0.1.0/26"
}

variable "relaySubnetName" {
  type        = string
  default     = "relaysubnet"
  description = "Name of the subnet to use for private link of relay namespace."
}

variable "relaySubnetAddressPrefix" {
  type        = string
  description = "Address space of the subnet to add for relay. e.g. 10.0.2.0/26"
}

variable "storageSubnetName" {
  type        = string
  default     = "storagesubnet"
  description = "Name of the subnet to use for storage account."
}

variable "storageSubnetAddressPrefix" {
  type        = string
  description = "Address space of the subnet to add for storage. e.g. 10.0.3.0/26"
}

variable "privateEndpointName" {
  type        = string
  default     = "cloudshellRelayEndpoint"
  description = "Name of Private Endpoint for Azure Relay."
}

variable "tagName" {
  type = map(string)
  default = {
    Environment = "cloudshell"
  }
  description = "Name of the resource tag."
}

variable "location" {
  type        = string
  default     = "resourceGroup().location"
  description = "Location for all resources."
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgName
  location            = var.location
  resource_group_name = var.location

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
    description                = "Deny traffic between container groups in cloudshellsubnet"
  }
}

resource "azurerm_subnet" "container_subnet" {
  name                      = var.containerSubnetName
  resource_group_name       = var.location
  virtual_network_name      = var.existingVNETName
  address_prefixes          = [var.containerSubnetAddressPrefix]
  network_security_group_id = azurerm_network_security_group.nsg.id

  delegation {
    name = "CloudShellDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoint {
    service   = "Microsoft.Storage"
    locations = [var.location]
  }
}

resource "azurerm_network_profile" "network_profile" {
  name                = "aci-networkProfile-${var.location}"
  location            = var.location
  resource_group_name = var.location
  container_network_interface {
    name = "eth-${var.containerSubnetName}"
    ip_configuration {
      name      = "ipconfig-${var.containerSubnetName}"
      subnet_id = azurerm_subnet.container_subnet.id
    }
  }

  depends_on = [azurerm_subnet.container_subnet]
}

resource "azurerm_role_assignment" "network_profile_role_assignment" {
  scope                = azurerm_network_profile.network_profile.id
  role_definition_name = "Network Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_relay_namespace" "relay_namespace" {
  name                = var.relayNamespaceName
  location            = var.location
  resource_group_name = var.location
  sku                 = "Standard"
  tags                = var.tagName
}

resource "azurerm_role_assignment" "relay_namespace_role_assignment" {
  scope                = azurerm_relay_namespace.relay_namespace.id
  role_definition_name = "Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_subnet" "relay_subnet" {
  name                                  = var.relaySubnetName
  resource_group_name                   = var.location
  virtual_network_name                  = var.existingVNETName
  address_prefixes                      = [var.relaySubnetAddressPrefix]
  private_endpoint_network_policies     = "Disabled"
  private_link_service_network_policies = "Enabled"
  depends_on                            = [azurerm_subnet.container_subnet]
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.privateEndpointName
  location            = var.location
  resource_group_name = var.location
  subnet_id           = azurerm_subnet.relay_subnet.id
  private_service_connection {
    name                           = var.privateEndpointName
    private_connection_resource_id = azurerm_relay_namespace.relay_namespace.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }
  tags = var.tagName
  depends_on = [
    azurerm_relay_namespace.relay_namespace,
    azurerm_subnet.relay_subnet
  ]
}

resource "azurerm_subnet" "storage_subnet" {
  name                 = var.storageSubnetName
  resource_group_name  = var.location
  virtual_network_name = var.existingVNETName
  address_prefixes     = [var.storageSubnetAddressPrefix]

  service_endpoint {
    service   = "Microsoft.Storage"
    locations = [var.location]
  }

  depends_on = [azurerm_subnet.relay_subnet]
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.location
  tags                = var.tagName
}

resource "azurerm_private_dns_a_record" "private_dns_a_record" {
  name                = var.relayNamespaceName
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.location
  ttl                 = 3600
  records             = ["IP_ADDRESS"]
  depends_on = [
    azurerm_private_endpoint.private_endpoint,
    azurerm_private_dns_zone.private_dns_zone
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  name                  = "${azurerm_private_dns_zone.private_dns_zone.name}/${var.relayNamespaceName}"
  resource_group_name   = var.location
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = var.tagName
  depends_on            = [azurerm_private_dns_zone.private_dns_zone]
}

output "vnetId" {
  value = azurerm_virtual_network.vnet.id
}

output "containerSubnetId" {
  value = azurerm_subnet.container_subnet.id
}

output "storageSubnetId" {
  value = azurerm_subnet.storage_subnet.id
}

output "networkSecurityGroupResourceId" {
  value = azurerm_network_security_group.nsg.id
}
