# Upgrade Obsolete resources

For example `azurerm_app_service_plan` might have been used to provision an App Service Plan and `azurerm_app_service` might have been used to provision an App Service hosted on that plan.

The `azurerm_app_service_plan` resource has been deprecated in version 3.0 of the AzureRM provider and will be removed in version 4.0. Please use azurerm_service_plan resource instead.
https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/resources/app_service_plan

The `azurerm_app_service` resource has been deprecated in version 3.0 of the AzureRM provider and will be removed in version 4.0. Please use azurerm_linux_web_app and azurerm_windows_web_app resources instead.
https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/resources/app_service

So what happens if somebody has provisioned an App Service Plan and an App Service using `azurerm` version 2.99 and then wants to upgrade to version 4.0?

First, while they investigate the impact of the upgrade they need to change the required version from `~> 2.99` to `= 2.99.0`. This will ensure there is no automatic upgrade.

## Upgrade to 3.x

First step is to upgrade to an upgrade bridge version of the provider. To go from `2.99` to `4.0` we should first upgrade to `3.x`. In order to upgrade to `3.x` we should upgrade to `3.116.0` as this version is the upgrade bridge version for the `3.x` version of the provider to get to `4.0`.

If you just try and run `terraform init` you will get this error message:

```
Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider
│ hashicorp/azurerm: locked provider registry.terraform.io/hashicorp/azurerm
│ 2.99.0 does not match configured version constraint ~> 3.116.0; must use
│ terraform init -upgrade to allow selection of new versions
```

So we need to run `terraform init -upgrade`.

After that we see that we have successfully initialized.

## Change the resource types

When we run `terraform plan` we get a warning message about deprecated resources.

```
│ Warning: Deprecated Resource
│ 
│   with azurerm_app_service_plan.main,
│   on main.tf line 14, in resource "azurerm_app_service_plan" "main":
│   14: resource "azurerm_app_service_plan" "main" {
│ 
│ The `azurerm_app_service_plan` resource has been superseded by the `azurerm_service_plan` resource. Whilst this resource will continue to be available in the 2.x
│ and 3.x releases it is feature-frozen for compatibility purposes, will no longer receive any updates and will be removed in a future major release of the Azure
│ Provider.
│ 
│ (and 3 more similar warnings elsewhere)
```

This is just telling us that it's okay we are still managing resources for the App Service Plan using the deprecated resource type of `azurerm_app_service_plan` but these resource types will be removed in the `4.x` version of the provider.

So we should upgrade this resource to the new type `azurerm_service_plan`.

This new resource has some new required attributes that we didn't specify in our previous configuration when we used the old `azurerm_app_service_plan`. 

- `os_type`
- `sku_name`

The `os_type` is a bit weird because we don't have anything related to this in our previous configuration. That could be that the attribute just didn't exist on the previous resource at all or we are using a default value without even knowing it. In this case, it is the latter. The `os_type` seems to have replaced an old attribute called `kind` which essentially has Operating System type as valid values. The default for `kind` was `Windows` so that's probably what we had originally and since changing this attribute requires the resource to be re-created we definitely don't want to accidentally change that.

It appears that the old `sku` nested block has been replaced with a single string attribute. Luckily it's not too difficult to find our SKU since its already in the valid values list so we just need to replace the example's value of `P1v2` with `S1`.

## Refactor with the `moved` block

You would think this would be the right thing to do but unfortunately it doesn't work.

```
│ Error: Unsupported `moved` across resource types
│ 
│   on main.tf line 33:
│   33: moved {
│ 
│ The provider "registry.terraform.io/hashicorp/azurerm" does not support moved operations across resource types and providers.
```

So that's not going to work. It seems the only way to get this to work is to remove and import.

## Refactor with the `terraform state mv` command

```
terraform state mv azurerm_app_service_plan.main azurerm_service_plan.main
```

But you get a similar error message:

```
Error: Invalid state move request
│ 
│ Cannot move azurerm_app_service_plan.main to azurerm_service_plan.main: resource types don't match.
```

## Remove and import

Before we do that we want to get the Azure Resource IDs for each of these resources.

First we open Terraform Console by executing the `terraform console` command.

Then we can just request the resource ID of the App Service Plan by typing in the fully qualified resource path and the attribute we want it to output.

```
azurerm_app_service_plan.main.id
```

This will then respond with the value stored in the `id` attribute of the `azurerm_app_service_plan.main` resource.

```
/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/serverfarms/asp-ep112-5w97hr
```

This will be useful in our `import` block in the next step.

Let's do the same for the App Service itself.

```
azurerm_app_service.main.id
```

Which yields the following `id`:

```
/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr
```

Now we can remove these resources from Terraform State using the `removed` block.

```
removed {
  from = azurerm_app_service_plan.main

  lifecycle {
    destroy = false
  }
}
```

### Remove the App Service 'App'

However we have to do this in a certain sequence because if we remove the App Service Plan without removing the dependent resources we will run into trouble. So first, we need to remove the App Service. This will remove all blocks that draw dependencies on the App Service Plan, which will allow us to remove it.

We can just temporarily comment out the `azurerm_app_service` resource block because we will need to refactor it in order to bring it back using and `import block`.

We get the following warning:

```
│ Warning: Some objects will no longer be managed by Terraform
│ 
│ If you apply this plan, Terraform will discard its tracking information for the following objects, but it will not delete them:
│  - azurerm_app_service.main
│ 
│ After applying this plan, Terraform will no longer manage these objects. You will need to import them into Terraform to manage them again.
```

We see proof of the resources that will be removed but not destroyed in the `terraform plan`.

```
Terraform will perform the following actions:

 # azurerm_app_service.main will no longer be managed by Terraform, but will not be destroyed
 # (destroy = false is set in the configuration)
 . resource "azurerm_app_service" "main" {
        id                                = "/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr"
        name                              = "app-ep112-5w97hr"
        tags                              = {}
        # (17 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

Plan: 0 to add, 0 to change, 0 to destroy.
```

Now that the apply is complete we can remove the `removed block` for the App Service since the removal has already taken place in the last `terraform apply`.


### Remove the App Service 'Plan'

```
removed {
  from = azurerm_app_service_plan.main

  lifecycle {
    destroy = false
  }
}
```

Run `terraform apply`. Now we are cooking with gas.

### Import the App Service Plan

```
Error: parsing "/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/serverfarms/asp-ep112-5w97hr": parsing segment "staticServerFarms": parsing the AppServicePlan ID: the segment at position 6 didn't match
│ 
│ Expected a AppServicePlan ID that matched:
│ 
│ > /subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Web/serverFarms/serverFarmValue
│ 
│ However this value was provided:
│ 
│ > /subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/serverfarms/asp-ep112-5w97hr
│ 
│ The parsed Resource ID was missing a value for the segment at position 6
│ (which should be the literal value "serverFarms").
```

It seems that the Resource ID had an all lower case segment for `serverfarms` and ARM wants `serverFarms`.

Changing this small value and EUREKA! It works!

```
azurerm_service_plan.main: Importing... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/serverFarms/asp-ep112-5w97hr]
azurerm_service_plan.main: Import complete [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/serverFarms/asp-ep112-5w97hr]

Apply complete! Resources: 1 imported, 0 added, 0 changed, 0 destroyed.
```

### Import the App Service App

So we already know that our App Service Plan has an Operating System type of `Windows`. Therefore it makes picking between `azurerm_windows_web_app` and `azurerm_linux_web_app` that much easier.

During the `terraform plan` for the import we can see the differences between our old configuration and our new configuration.

We can see that we are missing `app_settings`. Which should be easy enough to put back in place.

Under `site_config` we have a few properties that are getting reset. Some that are included in our original configuration and some that are not. The ones that are not included in our configuration are likely updated defaults that the new version of the provider is supplying to ARM.

- `always_on`: true
- `ftps_state`: `Disabled`
- `ip_restriction_default_action`: `Allow`
- `scm_ip_restriction_default_action`: `Allow`
- `use_32_bit_worker`: `true`

The `application_stack` is a block under the `site_config` nested block. I think the only value we are setting is `dotnet_version`.

```
azurerm_windows_web_app.main: Importing... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr]
azurerm_windows_web_app.main: Import complete [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr]
azurerm_windows_web_app.main: Modifying... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr]
azurerm_windows_web_app.main: Still modifying... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-...s/Microsoft.Web/sites/app-ep112-5w97hr, 10s elapsed]
azurerm_windows_web_app.main: Still modifying... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-...s/Microsoft.Web/sites/app-ep112-5w97hr, 20s elapsed]
azurerm_windows_web_app.main: Still modifying... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-...s/Microsoft.Web/sites/app-ep112-5w97hr, 30s elapsed]
azurerm_windows_web_app.main: Still modifying... [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-...s/Microsoft.Web/sites/app-ep112-5w97hr, 40s elapsed]
azurerm_windows_web_app.main: Modifications complete after 44s [id=/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr]

Apply complete! Resources: 1 imported, 0 added, 1 changed, 0 destroyed.
```

