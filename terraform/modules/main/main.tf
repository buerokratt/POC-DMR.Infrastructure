# Configure the Azure provider
terraform {
  backend "azurerm" {}
  #Use this when deploying locally
  #backend "local" {  
  #  path = "local/terraform.tfstate"
  #}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "storage_account" {
  source                   = "../resource_templates/storage_account"
  resource_group_name      = var.resource_group_name
  name                     = var.test_storage_account_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "terraform_storage_container" {
  source               = "../resource_templates/storage_container"
  name                 = var.terraform_container_name
  storage_account_name = var.test_storage_account_name
  depends_on = [
    module.storage_account
  ]
}