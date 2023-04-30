resource "azuredevops_project" "main" {
  name        = "Project Name"
  description = "Project Description"
}

resource "azuredevops_git_repository" "infra" {
  project_id = azuredevops_project.main.id
  name       = "infrastructure"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/markti/azdo-terraform-template-multi-stage.git"
  }
}