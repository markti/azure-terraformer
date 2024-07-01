data "azuredevops_project" "infra" {
  name = "infrastructure"
}

module "multi_stage_repo" {

  source  = "markti/azure-terraformer/azuredevops//modules/repo/multi-stage-terraform"
  version = "1.0.6"

  application_name      = var.application_name
  project_id            = data.azuredevops_project.infra.id
  repo_name             = var.application_name
  min_reviewers_enabled = false

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