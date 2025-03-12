provider "datadog" {
  api_url = local.datadog_api_url
  api_key = data.azurerm_key_vault_secret.datadog_api_key.value
  app_key = data.azurerm_key_vault_secret.datadog_app_key.value
}

provider "azurerm" {
  subscription_id     = var.subscription_id
  use_oidc            = true
  storage_use_azuread = true
  features {}
}