data "azurerm_client_config" "current" {}

data "azurerm_management_group" "this" {
  name = var.tenant_root_management_group_name
}

data "azurerm_key_vault" "this" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

data "azurerm_key_vault_secret" "datadog_site_name" {
  name         = var.key_vault_secrets_names.datadog_site_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "datadog_api_key" {
  name         = var.key_vault_secrets_names.datadog_api_key_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "datadog_app_key" {
  name         = var.key_vault_secrets_names.datadog_app_key_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "opsgenie_api_key" {
  for_each = { for idx, opsgenie_integration in var.opsgenie_integration : idx => opsgenie_integration }

  name         = each.value.name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "datadog_permissions" "current" {
  include_restricted = true
}
