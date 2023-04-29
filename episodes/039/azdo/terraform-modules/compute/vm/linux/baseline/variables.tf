variable location {
  type = string
}
variable name {
  type = string
}
variable resource_group_name {
  type = string
}
variable subnet_id {
  type = string
}
variable vm_size {
  type = string
}
variable vm_image_id {
  type    = string
  default = null
}
variable source_image_reference {
  type = object(
    {
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }
  )
  default = null
}
variable admin_user {
  type = string
}
variable ssh_public_key {
  type = string
}
variable boot_diagnostics_storage_account_uri {
  type    = string
  default = null
}