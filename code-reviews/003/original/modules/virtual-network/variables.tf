variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "client_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}



variable "app_subnet_prefix" {
  type        = string
  description = "Application subnet prefix"
}

variable "service_endpoints" {
  type        = list(string)
  description = "Service endpoints used by the solution"
}
variable "vnet_id" {
  type = string
}
