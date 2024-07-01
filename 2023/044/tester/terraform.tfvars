application_name        = "ep-044"
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
default_reviewers           = ["mark@tinderholt.net"]
minimum_number_of_reviewers = 1