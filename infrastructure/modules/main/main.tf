# Configure the Azure provider and backend
terraform {
  backend "azurerm" {}
  #Comment out the block above 'backend "azurerm" {}' and uncomment/use the backend block 
  #below when deploying locally
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

#(Required) Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Add terraform here e.g.
module "terraform_storage_container" {
  source               = "../resource_templates/storage_container"
  name                 = "test"
  storage_account_name = var.default_storage_account_name
}