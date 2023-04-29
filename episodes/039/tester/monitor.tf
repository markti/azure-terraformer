data azurerm_monitor_data_collection_rule vminsights {
  name                = "dcr-aztf-observability-dev-vminsights"
  resource_group_name = "rg-aztf-observability-dev"
}

resource azurerm_monitor_data_collection_rule_association vminsights {

  name                    = "dcra-${module.linux_vm.hostname}"
  target_resource_id      = module.linux_vm.id
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.vminsights.id
  description             = "Association of data collection rule for VM Insights."

}