variable "location" {
  type = string
}
variable "name" {
  type = string
}
variable "local_ip_address" {
  type = string
}
variable "local_address_space" {
  type = string
}
variable "preshared_key" {
  type = string
}
variable "boot_diagnostics_storage" {
  type = object(
    {
      storage_account = string
      resource_group  = string
    }
  )
}