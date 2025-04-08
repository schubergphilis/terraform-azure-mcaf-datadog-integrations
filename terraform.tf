terraform {
  required_version = ">= 1.9"
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.13"
    }
  }
}