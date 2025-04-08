# terraform-azure-mcaf-datadog-integrations

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 3.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | ~> 3.0.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application.datadog_saml_auth_application_registration](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.datadog_saml_auth_enterprise_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.spn](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.sp_password](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [azurerm_role_assignment.datadog](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [datadog_integration_azure.this](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/integration_azure) | resource |
| [datadog_integration_opsgenie_service_object.opsgenie_integration](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/integration_opsgenie_service_object) | resource |
| [datadog_integration_slack_channel.slack_integration_monitoring](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/integration_slack_channel) | resource |
| [datadog_integration_slack_channel.slack_integration_pager](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/integration_slack_channel) | resource |
| [datadog_organization_settings.organization](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/organization_settings) | resource |
| [datadog_role.enhanced_reader](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/role) | resource |
| [datadog_team.teams](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/team) | resource |
| [time_rotating.rotation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.datadog_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.datadog_app_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.datadog_site_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.opsgenie_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [datadog_permissions.current](https://registry.terraform.io/providers/datadog/datadog/latest/docs/data-sources/permissions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_integration_azure_config"></a> [datadog\_integration\_azure\_config](#input\_datadog\_integration\_azure\_config) | Datadog Azure Integration config | <pre>object({<br>    host_filters             = string<br>    app_service_plan_filters = string<br>    container_app_filters    = string<br>    automute                 = bool<br>    cspm_enabled             = bool<br>    custom_metrics_enabled   = bool<br>  })</pre> | n/a | yes |
| <a name="input_datadog_organization_name"></a> [datadog\_organization\_name](#input\_datadog\_organization\_name) | The Datadog organization name | `string` | n/a | yes |
| <a name="input_datadog_teams"></a> [datadog\_teams](#input\_datadog\_teams) | Datadog team configuration | <pre>map(<br>    object({<br>      description = string<br>      name        = string<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_datadog_users_filter"></a> [datadog\_users\_filter](#input\_datadog\_users\_filter) | Datadog users filter | <pre>object({<br>    domain = string<br>    status = string<br>  })</pre> | n/a | yes |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | The properties of the Key Vault to be used to store secrets | <pre>object({<br>    name                = string<br>    resource_group_name = string<br>  })</pre> | n/a | yes |
| <a name="input_key_vault_secrets_names"></a> [key\_vault\_secrets\_names](#input\_key\_vault\_secrets\_names) | The names of the secrets stored in the Key Vault | <pre>object({<br>    datadog_api_key_name  = string<br>    datadog_app_key_name  = string<br>    datadog_site_name     = string<br>    opsgenie_api_key_name = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_opsgenie_integration"></a> [opsgenie\_integration](#input\_opsgenie\_integration) | OpsGenie integration configuration | <pre>object({<br>    name   = string<br>    region = string<br>  })</pre> | n/a | yes |
| <a name="input_saml_autocreate_users_domains"></a> [saml\_autocreate\_users\_domains](#input\_saml\_autocreate\_users\_domains) | List of domains where the SAML automated user creation is enabled | `list(string)` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription id | `string` | n/a | yes |
| <a name="input_tenant_root_management_group_name"></a> [tenant\_root\_management\_group\_name](#input\_tenant\_root\_management\_group\_name) | Tenant root Azure management group name | `string` | n/a | yes |
| <a name="input_saml_autocreate_access_role"></a> [saml\_autocreate\_access\_role](#input\_saml\_autocreate\_access\_role) | n/a | `string` | `"ro"` | no |
| <a name="input_slack_integration_monitoring"></a> [slack\_integration\_monitoring](#input\_slack\_integration\_monitoring) | Slack integration configuration for Monitoring | <pre>object({<br>    account_name     = string<br>    channel_name     = string<br>    display_message  = bool<br>    display_notified = bool<br>    display_snapshot = bool<br>    display_tags     = bool<br>  })</pre> | `null` | no |
| <a name="input_slack_integration_pager"></a> [slack\_integration\_pager](#input\_slack\_integration\_pager) | Slack integration configuration for Pager alerts | <pre>object({<br>    account_name     = string<br>    channel_name     = string<br>    display_message  = bool<br>    display_notified = bool<br>    display_snapshot = bool<br>    display_tags     = bool<br>  })</pre> | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```