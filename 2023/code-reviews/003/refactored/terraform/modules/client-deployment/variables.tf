variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "client_name" {
  type        = string
  description = "client name"
  nullable    = false
}
variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}
variable "location_index" {
  type = number
}
variable "db_info" {
  type = object({
    sku_name             = string
    geo_backup_enabled   = bool
    db_size              = number
    storage_account_type = string
  })
}