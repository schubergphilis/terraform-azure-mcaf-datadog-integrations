resource "azurerm_role_assignment" "datadog" {
  scope                = data.azurerm_management_group.this.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azuread_service_principal.spn.id
}