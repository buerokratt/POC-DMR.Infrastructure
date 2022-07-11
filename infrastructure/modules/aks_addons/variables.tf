variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "ingress_public_ip_name" {
  description = "The resource name of the ingress public ip address"
  type        = string
}

variable "ingress_health_endpoint" {
  description = "The health endpoint used to determine the AKS cluster's liveness"
  type        = string
}
