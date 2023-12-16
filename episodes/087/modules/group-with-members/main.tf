locals {
  members = { for user in var.members : user => user }
}

data "azuread_user" "main" {
  for_each            = local.members
  user_principal_name = each.key
}

resource "azuread_group" "main" {
  display_name     = var.display_name
  owners           = local.combined_owners
  security_enabled = true
}

resource "azuread_group_member" "main" {
  for_each         = local.members
  group_object_id  = azuread_group.main.id
  member_object_id = data.azuread_user.main[each.key].object_id
}