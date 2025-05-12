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
  rotation_days = 365
}

resource "azuread_application_password" "app_password" {
  display_name   = "datadog-monitoring-app-password"
  application_id = azuread_application.application.id
  rotate_when_changed = {
    rotation = time_rotating.rotation.id
  }
}

# Block 1: End.

# Block 2: Create a new Azure AD application for Datadog SAML SSO

resource "azuread_application" "datadog_saml_auth_application_registration" {
  display_name = "datadog-saml-auth"
  #  identifier_uris         = ["https://app.datadoghq.eu/account/saml/metadata.xml"]
  identifier_uris         = ["https://app.datadoghq.eu/accounts/saml/metadata.xml"] # To Be Removed
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
  app_role {
    allowed_member_types = ["User"]
    description          = "Group role (used by SP for group assignment)"
    display_name         = "Group"
    enabled              = true
    id                   = "79e5a395-7ebc-4720-9a99-039e9bd57f0e"
  }
  web {
    homepage_url = "https://www.datadog.com/"
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
  login_url                     = "${local.datadog_app_url}/account/login/id/${datadog_organization_settings.organization.id}"
  preferred_single_sign_on_mode = "saml"
  notification_email_addresses  = var.saml_notification_email_addresses
  feature_tags {
    enterprise            = true
    custom_single_sign_on = true
  }
}
resource "azuread_claims_mapping_policy" "datadog_saml_auth_claims_mapping_policy" {
  display_name = "datadog-saml-auth-claims-mapping-policy"
  definition = [jsonencode({
    ClaimsMappingPolicy = {
      Version              = 1
      IncludeBasicClaimSet = false
      ClaimsSchema = [
        # Required claim: email address
        {
          Source        = "user"
          ID            = "mail"
          SamlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        },

        # Name ID: user.userprincipalname with email format
        {
          Source                   = "user"
          ID                       = "userPrincipalName"
          SamlClaimType            = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
          SamlNameIdentifierFormat = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
        },

        # Additional claim: groups
        {
          Source        = "user"
          ID            = "groups"
          SamlClaimType = "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
        },

        # Additional claim: given name
        {
          Source        = "user"
          ID            = "givenName"
          SamlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
        },

        # Additional claim: name
        {
          Source        = "user"
          ID            = "userPrincipalName"
          SamlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
        },

        # Additional claim: surname
        {
          Source        = "user"
          ID            = "surname"
          SamlClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
        }
      ]
    }
  })]
}
resource "azuread_service_principal_claims_mapping_policy_assignment" "app" {
  claims_mapping_policy_id = azuread_claims_mapping_policy.datadog_saml_auth_claims_mapping_policy.id
  service_principal_id     = azuread_service_principal.datadog_saml_auth_enterprise_application.id
}
# Generate and assign a SAML token signing certificate
resource "azuread_service_principal_token_signing_certificate" "saml_signing_cert" {
  service_principal_id = azuread_service_principal.datadog_saml_auth_enterprise_application.id
  display_name         = "CN=DataDog SAML SSO Certificate"
  end_date             = var.saml_certificate_end_date
}

# Assign Entra ID Groups to the Enterprise Application
resource "azuread_app_role_assignment" "group_assignments" {
  for_each = data.azuread_group.sso_groups

  principal_object_id = each.value.id
  resource_object_id  = azuread_service_principal.datadog_saml_auth_enterprise_application.id

  app_role_id = one([
    for role in azuread_application.datadog_saml_auth_application_registration.app_role :
    role.id if role.display_name == "Group"
  ])
}

# Block 2: End.

