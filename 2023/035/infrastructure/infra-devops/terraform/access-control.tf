resource azuread_group admin {
  display_name     = "${var.application_name}-${var.environment_name}-admin"
  owners           = [data.azurerm_client_config.current.object_id]
  security_enabled = true
}

locals {
  admin_users = [
    "mark@tinderholt.net", 
    "keyser@tinderholt.net"
  ]
}

data azuread_user admin_user {

  count               = length(local.admin_users)
  user_principal_name = local.admin_users[count.index]

}

resource azuread_group_member admin_member {

  count            = length(local.admin_users)
  group_object_id  = azuread_group.admin.id
  member_object_id = data.azuread_user.admin_user[count.index].id

}
