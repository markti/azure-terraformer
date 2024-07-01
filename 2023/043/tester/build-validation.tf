resource "azuredevops_branch_policy_build_validation" "main" {

  count = length(var.environments)

  project_id = azuredevops_project.main.id

  enabled  = true
  blocking = true

  settings {
    display_name        = "terraform plan ${var.environments[count.index]}"
    build_definition_id = azuredevops_build_definition.plan[count.index].id
    valid_duration      = 720
    filename_patterns = [
      "/src/terraform/*"
    ]

    scope {
      match_type = "DefaultBranch"
    }
  }
}