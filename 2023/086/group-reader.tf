locals {
  reader_users = { for user in var.reader_users : user => user }
}

data "azuread_user" "readers" {
  for_each            = local.reader_users
  user_principal_name = each.key
}

resource "azuread_group" "readers" {
  display_name     = "Foo-DEV Readers"
  owners           = local.combined_owners
  security_enabled = true
}

resource "azuread_group_member" "readers" {
  for_each         = local.reader_users
  group_object_id  = azuread_group.readers.id
  member_object_id = data.azuread_user.readers[each.key].object_id
}