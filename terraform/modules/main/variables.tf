variable "resource_group_name" {
  type        = string
  description = " (Required) Specifies the name which should be used for this Resource Group"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the Azure region where the resource group should exist"
}

variable "test_storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the default storage account"
}

variable "terraform_container_name" {
  type        = string
  description = "(Required) Specifies the name of the container that stores .tfstate file which should be created within the storage account"
}