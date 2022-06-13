variable "name" {
  description = "Name of the azure traffic manager"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "aks_pip" {
  description = "Name of the Azure Public IP for the AKS cluster"
  type        = map(string)
}

variable "environment_name" {
  description = "Name of the environment we're provisioning"
  type        = string
}
