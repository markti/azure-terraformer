variable "client_name" {
  type        = string
  description = "client name"
  nullable    = false
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}


variable "app_subnet_prefix" {
  type        = string
  description = "Application subnet prefix"
  nullable    = false
}
variable "db_info" {
  type = object({
    sku_name             = string
    geo_backup_enabled   = bool
    db_size              = number
    storage_account_type = string
  })
}

variable "keyvault_access_ids" {
  type        = set(string)
  description = "List of Objects IDs for user principals who need access to keyvault"
}



