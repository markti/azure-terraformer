data "azuredevops_project" "infra" {
  name = "infrastructure"
}

resource "random_string" "main" {
  length  = 6
  lower   = true
  upper   = false
  special = false
}

locals {
  randomized_application_name = "${var.application_name}-${random_string.main.result}"
}

module "multi_stage_repo" {

  source  = "markti/azure-terraformer/azuredevops//modules/repo/multi-stage-terraform"
  version = "1.0.7"

  application_name = local.randomized_application_name
  project_id       = data.azuredevops_project.infra.id
  repo_name        = local.randomized_application_name

  environments = {
    dev = {
      azure_credential = var.dev_creds
      azure_backend    = var.dev_backend
    }
    prod = {
      azure_credential = var.prod_creds
      azure_backend    = var.prod_backend
    }
  }

}