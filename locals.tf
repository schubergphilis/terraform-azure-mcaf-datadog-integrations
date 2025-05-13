locals {
  datadog_api_url = "https://api.${data.azurerm_key_vault_secret.datadog_site_name.value}"
  datadog_app_url = "https://app.${data.azurerm_key_vault_secret.datadog_site_name.value}"
  # entraid_datadog_application_saml_identifier_uris = [
  #   "${local.datadog_app_url}/account/saml/metadata.xml"
  # ]
}
