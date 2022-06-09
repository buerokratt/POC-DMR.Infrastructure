#
# Secret variables
#

variable "client_id" {
  description = "The service principal's client ID"
  type        = string
}

variable "client_secret" {
  description = "The service principal's client secret"
  type        = string
}

variable "tenant_id" {
  description = "The directory/tenant that the service principal lives in"
  type        = string
}

variable "subscription_id" {
  description = "The subscription that terraform will deploy to"
  type        = string
}

#
# Environment specific variables
#

variable "environment_name" {
  description = "The name of the environment being provisioned"
  type        = string
}

variable "environment_postfix" {
  description = "(Optional) A unique value that is appended to get the complete environment name."
  type        = string
  default     = ""
}

variable "keyvault_enabled_for_deployment" {
  description = "true/false for VMs to be able to fetch secrets/keys/certificates"
  type        = bool
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "true/false for usage of secrets/keys/certificates for disk encryption"
  type        = bool
}

variable "keyvault_enabled_for_template_deployment" {
  description = "true/false for deployments to be able to fetch secrets/keys/certificates"
  type        = bool
}

variable "keyvault_purge_protection_enabled" {
  description = "true/false for enabling purge protection"
  type        = bool
}
