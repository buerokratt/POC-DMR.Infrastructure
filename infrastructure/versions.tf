# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }

    helm = {
      source  = "helm"
      version = ">= 2.4.1"
    }

    kubernetes = {
      source  = "kubernetes"
      version = ">= 2.8.0"
    }
  }
  required_version = ">= 1.1.0"

  #
  # LOCAL DEV: Comment out the 'backend "azurerm" {}' block below - this ensures the tfstate to be stored locally
  #

  backend "azurerm" {}
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}
