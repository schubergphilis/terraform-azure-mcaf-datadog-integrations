# Create new team resource

resource "datadog_team" "teams" {
  for_each    = var.datadog_teams
  handle      = each.key
  name        = each.value.name
  description = each.value.description
}

resource "datadog_role" "enhanced_reader" {
  name = "enhanced-reader"
  permission {
    id = data.datadog_permissions.current.permissions.azure_configuration_read
  }
  permission {
    id = data.datadog_permissions.current.permissions.integrations_read
  }
}