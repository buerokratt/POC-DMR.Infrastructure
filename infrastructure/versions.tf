# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
  required_version = ">= 1.1.0"

  backend "azurerm" {}

  # LOCAL DEV: Comment out the block above 'backend "azurerm" {}' and uncomment/use the backend block 
  # below when deploying locally - this ensure tfstate to be stored locally/remotely

  #backend "local" {
  #  path = "/terraform.tfstate"
  #}
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}
