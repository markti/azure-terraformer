application_name        = "ep-043"
environments            = ["dev", "prod"]
repository_template_url = "https://github.com/markti/azdo-terraform-template-multi-stage"
azure_backends = {
  "dev" = {
    resource_group  = "rg-terraform-state"
    storage_account = "ststate67875"
    container       = "tfstate"
  }
  "prod" = {
    resource_group  = "rg-terraform-state"
    storage_account = "ststate96934"
    container       = "tfstate"
  }
}