output "app_service_plan_id" {
  value       = module.main.app_service_plan_id
  description = "Service Plan ID"
}

output "sqlserver_id" {
  value = module.main.sqlserver_id
}

output "vnet_id" {
  value = module.main.vnet_id

}

output "db_username" {
  value = module.main.db_username
}
output "db_password" {
  value     = module.main.db_password
  sensitive = true
}
