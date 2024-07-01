resource "azuredevops_variable_group" "azure_credentials" {
  project_id   = azuredevops_project.main.id
  name         = "Azure Credentials"
  description  = ""
  allow_access = true

  variable {
    name  = "ARM_CLIENT_ID"
    value = ""
  }
  variable {
    name         = "ARM_CLIENT_SECRET"
    secret_value = ""
    is_secret    = true
  }
  variable {
    name  = "ARM_TENANT_ID"
    value = ""
  }
  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = ""
  }
}

resource "azuredevops_variable_group" "azure_backend" {
  project_id   = azuredevops_project.main.id
  name         = "Azure Terraform Backend"
  description  = ""
  allow_access = true

  variable {
    name  = "BACKEND_RESOURCE_GROUP_NAME"
    value = "rg-terraform-state"
  }
  variable {
    name  = "BACKEND_STORAGE_ACCOUNT_NAME"
    value = ""
  }
  variable {
    name  = "BACKEND_STORAGE_CONTAINER_NAME"
    value = "tfstate"
  }
}