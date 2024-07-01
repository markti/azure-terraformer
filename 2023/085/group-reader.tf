locals {
  reader_users = { for user in var.reader_users : user => user }
}

resource "azuread_group" "readers" {
  display_name     = "Foo-DEV Readers"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}
resource "azuread_group_member" "readers" {
  for_each         = local.reader_users
  group_object_id  = azuread_group.readers.id
  member_object_id = each.key
}