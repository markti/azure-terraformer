variable "resource_group" {
  type        = string
  description = "The resource group"
  default     = ""
}

variable "client_name" {
  type        = string
  description = "The name of your application"
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
  default     = ""
}


variable "subnet_id" {
  type        = string
  description = "The subnet from which the access is allowed"
}
variable "sqlserver_id" {
  type        = string
  description = "The subnet from which the access is allowed"
}

variable "db_info" {
  description = "Details about type of DB which needs to be created, details can be found here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database"
  type = object({
    sku_name             = string
    db_size              = number
    storage_account_type = string
  })
}
