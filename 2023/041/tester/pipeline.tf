resource "azuredevops_build_definition" "plan" {
  project_id = azuredevops_project.main.id
  name       = "Terraform Apply"
  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = false
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.infra.id
    branch_name = azuredevops_git_repository.infra.default_branch
    yml_path    = ".azdo-pipelines/terraform-multi-stage.yaml"
  }

  # 6 clicks
  variable_groups = [
    azuredevops_variable_group.azure_credentials.id,
    azuredevops_variable_group.azure_backend.id
  ]

  variable {
    name  = "ApplicationName"
    value = "foo"
  }
  variable {
    name  = "EnvironmentName"
    value = "dev"
  }
  variable {
    name  = "WorkingDirectory"
    value = "src/terraform"
  }
}