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

variable "database_username" {
  type        = string
  description = "The database username"
}

variable "database_password" {
  type        = string
  description = "The database password"
}

variable "storage_account_key" {
  type        = string
  description = "The Azure Storage Account key"
}

variable "subnet_id" {
  type        = string
  description = "The subnet from which the access is allowed"
}

variable "myip" {
  type        = string
  description = "The IP address of the current client. It is required to provide access to this client to be able to create the secrets"
}
variable "keyvault_access_ids" {
  type        = set(string)
  description = "List of Azure ADs which shall have access to keyvault"
}
