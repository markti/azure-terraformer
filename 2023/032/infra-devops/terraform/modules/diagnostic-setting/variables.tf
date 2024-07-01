variable name {
  type = string
}
variable resource_id {
  type = string
}
variable storage_account_id {
  type = string
}
variable log_analytics_workspace_id {
  type = string
}
variable logs {
  type = list(string)
}
variable metrics {
  type = list(string)
}
variable retention_period {
  type = number
}