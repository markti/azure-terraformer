variable "resource_group" {
  type        = string
  description = "The resource group"
}
variable "name" {
  type        = string
  description = "The name of your application"
}
variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}
variable "tenant_id" {
  type = string
}
variable "subnets" {
  type        = list(string)
  description = "The subnet from which the access is allowed"
}
variable "ip_rules" {
  type        = list(string)
  description = "The IP address of the current client. It is required to provide access to this client to be able to create the secrets"
}