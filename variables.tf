# The variables below are for Datadog
variable "datadog_organization_name" {
  description = "The Datadog organization name"
  type        = string
}

variable "datadog_integration_azure_config" {
  description = "Datadog Azure Integration config"
  type = object({
    host_filters             = string
    app_service_plan_filters = string
    container_app_filters    = string
    automute                 = bool
    cspm_enabled             = bool
    custom_metrics_enabled   = bool
  })
}

variable "datadog_users_filter" {
  description = "Datadog users filter"
  type = object({
    domain = string
    status = string
  })
}

variable "datadog_teams" {
  description = "Datadog team configuration"
  type = map(
    object({
      description = string
      name        = string
    })
  )
}

# The variables below are for the integration of Datadog with Opsgenie
variable "opsgenie_integration" {
  description = "OpsGenie integration configuration"
  type = list(object({
    name   = string
    region = string
  }))
}

# The variables below are for the integration of Datadog with Slack
variable "slack_integration_pager" {
  description = "Slack integration configuration for Pager alerts"
  type = object({
    account_name     = string
    channel_name     = string
    display_message  = bool
    display_notified = bool
    display_snapshot = bool
    display_tags     = bool
  })
  default = null
}

variable "slack_integration_monitoring" {
  description = "Slack integration configuration for Monitoring"
  type = object({
    account_name     = string
    channel_name     = string
    display_message  = bool
    display_notified = bool
    display_snapshot = bool
    display_tags     = bool
  })
  default = null
}

# Azure
variable "subscription_id" {
  description = "Azure subscription id"
  type        = string
}

variable "tenant_root_management_group_name" {
  description = "Tenant root Azure management group name"
  type        = string
}

variable "key_vault" {
  description = "The properties of the Key Vault to be used to store secrets"
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "key_vault_secrets_names" {
  description = "The names of the secrets stored in the Key Vault"
  type = object({
    datadog_api_key_name = string
    datadog_app_key_name = string
    datadog_site_name    = string
    #   opsgenie_api_key_name = optional(string, null)
  })
}

# Entra ID
variable "saml_autocreate_users_domains" {
  type        = list(string)
  description = "List of domains where the SAML automated user creation is enabled"
}

variable "saml_autocreate_access_role" {
  type    = string
  default = "ro"
  validation {
    condition     = contains(["ro", "st", "adm", "ERROR"], var.saml_autocreate_access_role)
    error_message = "Valid value is one of the following: `ro`, `st`, `adm`, `ERROR`"
  }
}
