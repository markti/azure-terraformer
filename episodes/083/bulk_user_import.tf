locals {
  user_list = jsondecode(file("users.json"))
}

resource "azuread_user" "bulk" {

  count = length(local.user_list)

  user_principal_name = local.user_list[count.index].EmailAddress
  display_name        = "${local.user_list[count.index].FirstName} ${local.user_list[count.index].LastName}"
  mail_nickname = lower(
    join("",
      [
        substr(local.user_list[count.index].FirstName, 0, 1),
        local.user_list[count.index].LastName
      ]
    )
  )
  password = random_password.bulk[count.index].result
}

resource "random_password" "bulk" {

  count = length(local.user_list)

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}