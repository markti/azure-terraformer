output "primary_region" {
  value = module.rando_region.result[0]
}
output "fault_domain" {
  value = module.vm.fault_domain
}
output "zone" {
  value = module.vm.zone
}