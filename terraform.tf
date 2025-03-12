terraform {
  required_version = ">= 1.8"
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = ">= 3.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
  }
}