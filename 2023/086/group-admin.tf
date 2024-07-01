locals {
  admin_users = { for user in var.admin_users : user => user }
}

data "azuread_user" "admins" {
  for_each            = local.admin_users
  user_principal_name = each.key
}

resource "azuread_group" "admins" {
  display_name     = "Foo-DEV Admins"
  owners           = local.combined_owners
  security_enabled = true
}

resource "azuread_group_member" "admins" {
  for_each         = local.admin_users
  group_object_id  = azuread_group.admins.id
  member_object_id = data.azuread_user.admins[each.key].object_id
}