terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

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
  description = "Address space of the subnet to add for cloud shell."
}

variable "relaySubnetName" {
  type        = string
  default     = "relaysubnet"
  description = "Name of the subnet to use for private link of relay namespace."
}

variable "relaySubnetAddressPrefix" {
  type        = string
  description = "Address space of the subnet to add for relay."
}

variable "storageSubnetName" {
  type        = string
  default     = "storagesubnet"
  description = "Name of the subnet to use for storage account."
}

variable "storageSubnetAddressPrefix" {
  type        = string
  description = "Address space of the subnet to add for storage."
}

variable "privateEndpointName" {
  type        = string
  default     = "cloudshellRelayEndpoint"
  description = "Name of Private Endpoint for Azure Relay."
}

variable "tagName" {
  type        = map(string)
  default     = { "Environment" = "cloudshell" }
  description = "Name of the resource tag."
}

variable "location" {
  type        = string
  default     = "resourceGroup().location"
  description = "Location for all resources."
}

locals {
  networkProfileName          = "aci-networkProfile-${var.location}"
  contributorRoleDefinitionId = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  networkRoleDefinitionId     = "4d97b98b-1d4f-4787-a291-c67834d212e7"
  privateDnsZoneName          = "privatelink.servicebus.windows.net"
  vnetResourceId              = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.existingVNETName
  location            = var.location
  address_space       = [var.containerSubnetAddressPrefix]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "container_subnet" {
  name                 = var.containerSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.containerSubnetAddressPrefix]

  delegation {
    name = "CloudShellDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints         = ["Microsoft.Storage"]
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

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

resource "azurerm_network_profile" "network_profile" {
  name                = local.networkProfileName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  container_network_interface {
    name = "eth-${var.containerSubnetName}"
    ip_configuration {
      name      = "ipconfig-${var.containerSubnetName}"
      subnet_id = azurerm_subnet.container_subnet.id
    }
  }

  tags = var.tagName
}

resource "azurerm_role_assignment" "network_profile_role" {
  scope                = azurerm_network_profile.network_profile.id
  role_definition_name = "Network Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_relay_namespace" "relay_namespace" {
  name                = var.relayNamespaceName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  tags = var.tagName
}

resource "azurerm_role_assignment" "relay_namespace_role" {
  scope                = azurerm_relay_namespace.relay_namespace.id
  role_definition_name = "Contributor"
  principal_id         = var.azureContainerInstanceOID
}

resource "azurerm_subnet" "relay_subnet" {
  name                 = var.relaySubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.relaySubnetAddressPrefix]

  private_endpoint_network_policies     = "Disabled"
  private_link_service_network_policies = "Enabled"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.privateEndpointName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.relay_subnet.id

  private_service_connection {
    name                           = var.privateEndpointName
    private_connection_resource_id = azurerm_relay_namespace.relay_namespace.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  tags = var.tagName
}

resource "azurerm_subnet" "storage_subnet" {
  name                 = var.storageSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.storageSubnetAddressPrefix]

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = local.privateDnsZoneName
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = var.relayNamespaceName
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.private_endpoint.custom_dns_configs[0].ip_addresses[0]]
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  name                  = var.relayNamespaceName
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name

  registration_enabled = false
  tags                 = var.tagName
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

output "nsgDefaultRules" {
  value = azurerm_network_security_group.nsg.default_security_rule_ids
}
