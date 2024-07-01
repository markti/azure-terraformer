data "azuread_client_config" "current" {
}

locals {
  combined_owners = distinct(
    concat(
      [data.azuread_client_config.current.object_id],
      data.azuread_user.group_owners.*.object_id
    )
  )
}

data "azuread_user" "group_owners" {
  count               = length(var.owners)
  user_principal_name = var.owners[count.index]
}