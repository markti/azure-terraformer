resource "azuread_user" "thomas_callahan_iii" {
  user_principal_name = "thomas_callahan_iii@tinderholt.net"
  display_name        = "Thomas Callahan III"
  mail_nickname       = "tommyboy"
  password            = random_password.thomas_callahan_iii.result
}

resource "random_password" "thomas_callahan_iii" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
data "azurerm_subscription" "current" {
}
data "azurerm_client_config" "current" {
}

resource "azurerm_role_assignment" "thomas_callahan_iii" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.thomas_callahan_iii.object_id
}