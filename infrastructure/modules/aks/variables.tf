variable "name" {
  description = "Name of the azure kubernetes cluster"
  type        = string
}

variable "resource_group" {
  description = "The resource group"
  type = object({
    name     = string,
    location = string
  })
}

variable "keyvault_id" {
  description = "ID of the KV where the Kubeconfig will be stored"
  type        = string
}
