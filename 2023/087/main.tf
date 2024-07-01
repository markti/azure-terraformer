data "azuread_client_config" "current" {
}
data "azurerm_subscription" "current" {
}

module "admins" {
  source = "./modules/group-with-members"

  display_name = "Foo-DEV Admins"
  owners       = var.group_owners
  members = [
    "mark@tinderholt.net"
  ]

}

module "readers" {
  source = "./modules/group-with-members"

  display_name = "Foo-DEV Readers"
  owners       = var.group_owners
  members = [
    "keyser@tinderholt.net"
  ]

}