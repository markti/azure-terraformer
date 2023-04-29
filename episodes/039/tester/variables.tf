variable location {
  type = string
}
variable name {
  type = string
}
variable boot_diagnostics_storage {
  type = object(
    {
      storage_account = string
      resource_group  = string
    }
  )
}