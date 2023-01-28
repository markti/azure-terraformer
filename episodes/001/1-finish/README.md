1. [Azure Naming Conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
2. Create Resource Group
[`azurerm_resource_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
3. Add Random String to supplement the RG name [`random_string`](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

4. Create a Storage Account [`azurerm_storage_account`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
5. Create Log Analytics Workspace [`azurerm_log_analytics_workspace`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)
6. Diagnostic Setting [`azurerm_monitor_diagnostic_setting`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
7. Azure Subscription [`azurerm_subscription`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)