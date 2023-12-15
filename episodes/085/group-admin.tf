locals {
  admin_users = { for user in var.admin_users : user => user }
}

resource "azuread_group" "admins" {
  display_name     = "Foo-DEV Admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}
resource "azuread_group_member" "admins" {
  for_each         = local.admin_users
  group_object_id  = azuread_group.admins.id
  member_object_id = each.key
}