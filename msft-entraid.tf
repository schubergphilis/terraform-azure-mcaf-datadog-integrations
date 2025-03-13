# Block 1: Create a new Azure AD application for Datadog Metric Collection

resource "azuread_application" "application" {
  display_name = "datadog-monitoring"
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "spn" {
  client_id                    = azuread_application.application.client_id
  owners                       = azuread_application.application.owners
  app_role_assignment_required = false

  tags = [
    "AppServiceIntegratedApp",
    "HideApp",
    "WindowsAzureActiveDirectoryIntegratedApp",
  ]
}

resource "time_rotating" "rotation" {
  rotation_days = 60
}

resource "azuread_service_principal_password" "sp_password" {
  display_name         = "datadog-service-principal-password"
  service_principal_id = azuread_service_principal.spn.object_id
  rotate_when_changed = {
    rotation = time_rotating.rotation.id
  }
}

# Block 1: End.

# Block 2: Create a new Azure AD application for Datadog SAML SSO

resource "azuread_application" "datadog_saml_auth_application_registration" {
  display_name            = "datadog-saml-auth"
  owners                  = [data.azurerm_client_config.current.object_id]
  group_membership_claims = ["ApplicationGroup"]

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 1

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access Datadog on behalf of the signed-in user."
      admin_consent_display_name = "Access Datadog"
      enabled                    = true
      id                         = "9cf7ade3-420f-4a2c-beef-02dcdbcb679b"
      type                       = "User"
      user_consent_description   = "Allow the application to access Datadog on your behalf."
      user_consent_display_name  = "Access Datadog"
      value                      = "user_impersonation"
    }
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "User"
    display_name         = "User"
    enabled              = true
    id                   = "cb86c681-9dfb-4580-9d9a-303863de3d91"
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "msiam_access"
    display_name         = "msiam_access"
    enabled              = true
    id                   = "420578d9-e592-46f2-8e9e-c537e5e5ce76"
  }

  optional_claims {
    saml2_token {
      additional_properties = []
      essential             = false
      name                  = "groups"
    }
  }

  web {
    homepage_url = "${local.datadog_app_url}/account/saml/assertion?metadata=datadog|ISV9.1|primary|z"
    redirect_uris = [
      "${local.datadog_app_url}/account/saml/assertion"
    ]
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  feature_tags {
    enterprise = true
  }
}

resource "azuread_service_principal" "datadog_saml_auth_enterprise_application" {
  client_id                     = azuread_application.datadog_saml_auth_application_registration.client_id
  app_role_assignment_required  = true
  #service_principal_names       = local.entraid_datadog_application_saml_identifier_uris
  login_url                     = "${local.datadog_app_url}/account/login/id/${datadog_organization_settings.organization.id}"
  preferred_single_sign_on_mode = "saml"
  feature_tags {
    custom_single_sign_on = true
  }

}

resource "azuread_claims_mapping_policy" "datadog_saml_auth_claims_mapping_policy" {
  display_name = "datadog-saml-auth-claims-mapping-policy"
  definition = [
    jsonencode(
      {
        "ClaimsMappingPolicy" = {
          "Version"              = 1,
          "IncludeBasicClaimSet" = "true",
          "ClaimsSchema" = [
            {
              samlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress",
              source        = "User",
              id            = "mail"
            },
            {
              samlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name",
              source        = "User",
              id            = "userprincipalname"
            }
          ]
        }
      }
    )
  ]
}

resource "azuread_service_principal_claims_mapping_policy_assignment" "app" {
  claims_mapping_policy_id = azuread_claims_mapping_policy.datadog_saml_auth_claims_mapping_policy.id
  service_principal_id     = azuread_service_principal.datadog_saml_auth_enterprise_application.id
}

# Block 2: End.
