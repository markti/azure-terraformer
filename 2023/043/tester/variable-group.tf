resource "azuredevops_variable_group" "azure_credentials" {

  count = length(var.environments)

  project_id   = azuredevops_project.main.id
  name         = "azure-credentials-${var.environments[count.index]}"
  description  = "Azure Credentials for ${var.environments[count.index]} environment"
  allow_access = true

  variable {
    name  = "ARM_CLIENT_ID"
    value = var.azure_credentials[var.environments[count.index]].client_id
  }
  variable {
    name         = "ARM_CLIENT_SECRET"
    secret_value = var.azure_credentials[var.environments[count.index]].client_secret
    is_secret    = true
  }
  variable {
    name  = "ARM_TENANT_ID"
    value = var.azure_credentials[var.environments[count.index]].tenant_id
  }
  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = var.azure_credentials[var.environments[count.index]].subscription_id
  }
}

resource "azuredevops_variable_group" "azure_backend" {

  count = length(var.environments)

  project_id   = azuredevops_project.main.id
  name         = "azure-backend-${var.environments[count.index]}"
  description  = "Azure Terraform Backend for ${var.environments[count.index]} environment"
  allow_access = true

  variable {
    name  = "BACKEND_RESOURCE_GROUP_NAME"
    value = var.azure_backends[var.environments[count.index]].resource_group
  }
  variable {
    name  = "BACKEND_STORAGE_ACCOUNT_NAME"
    value = var.azure_backends[var.environments[count.index]].storage_account
  }
  variable {
    name  = "BACKEND_STORAGE_CONTAINER_NAME"
    value = var.azure_backends[var.environments[count.index]].container
  }
}