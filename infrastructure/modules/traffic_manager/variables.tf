variable "name" {
  description = "Name of the azure traffic manager"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "aks_pip_id" {
  description = "ID of the Ingress Public IP for the AKS cluster"
  type        = string
}

variable "environment_name" {
  description = "Name of the environment we're provisioning"
  type        = string
}

variable "aks_ingress_health_endpoint" {
  description = "Endpoint for AKS cluster health check"
  type        = string
}
