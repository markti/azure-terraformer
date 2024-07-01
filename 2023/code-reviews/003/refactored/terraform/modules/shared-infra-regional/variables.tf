variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}
variable "location_index" {
  type = number
}
variable "administrator_login" {
  type        = string
  description = "The SQL Server administrator login"
  default     = "sqladmin"
}
variable "address_space" {
  type        = string
  description = "Virtual Network address space"
  default     = "10.11.0.0/16"
}