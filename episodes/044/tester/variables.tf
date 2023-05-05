variable "application_name" {
  type = string
}
variable "environments" {
  type = list(string)
}
variable "azure_credentials" {
  type = map(
    object(
      {
        client_id       = string
        client_secret   = string
        tenant_id       = string
        subscription_id = string
      }
    )
  )
}
variable "azure_backends" {
  type = map(
    object({
      resource_group  = string
      storage_account = string
      container       = string
    })
  )
}
variable "repository_template_url" {
  type = string
}
variable "default_reviewers" {
  type = list(string)
}
variable "minimum_number_of_reviewers" {
  type = number
}