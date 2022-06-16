variable "resource_group_name" {
  description = "Resource Group name to host keyvault"
  type        = string
}

variable "location" {
  description = "key vault location"
  type        = string
}

variable "tenant_id" {
  description = "the tenant id of service principal who is creating the keyvault"
  type        = string
}

variable "name" {
  description = "Key vault name"
  type        = string
}

variable "enabled_for_deployment" {
  description = "true/false for VMs to able to fetch secrets/keys/certificates"
  type        = bool
}

variable "enabled_for_disk_encryption" {
  description = "true/false for usage of secrets/keys/certificates for disk encryption"
  type        = bool
}

variable "enabled_for_template_deployment" {
  description = "true/false for deployments to able to fetch secrets/keys/certificates"
  type        = bool
}

variable "purge_protection_enabled" {
  description = "true/false for enabling purge protection"
  type        = bool
}