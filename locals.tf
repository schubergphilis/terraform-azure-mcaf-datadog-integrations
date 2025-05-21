locals {
  datadog_api_url = "https://api.${var.datadog_site_name}"
  datadog_app_url = "https://app.${var.datadog_site_name}"
  #entraid_datadog_application_saml_identifier_uris = [
  #  "${local.datadog_app_url}/account/saml/metadata.xml"
  #]
}