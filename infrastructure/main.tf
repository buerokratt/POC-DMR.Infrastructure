locals {
  project_name       = "buerokratt"
  project_name_short = "byk"
  environment        = "${var.environment_name}${var.environment_postfix}"
  primary_location   = "uksouth"

  # buerokratt-dev-rg
  resource_group_name = "${local.project_name}-${local.environment}-rg"

  # bykdevstg
  storage_account_name = "${local.project_name_short}${local.environment}stg"

  # byk-dev-kv
  keyvault_name = "${local.project_name_short}-${local.environment}-kv"

  # byk-dev-aks
  aks_name = "${local.project_name_short}-${local.environment}-aks"
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source                  = "./modules/resource_templates/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.primary_location
}

module "key_vault" {
  source                                   = "./modules/resource_templates/key_vault"
  resource_group_name                      = module.resource_group.resource_group_name
  keyvault_name                            = local.keyvault_name
  keyvault_location                        = local.primary_location
  keyvault_tenant_id                       = data.azurerm_client_config.current.tenant_id
  keyvault_enabled_for_deployment          = var.keyvault_enabled_for_deployment
  keyvault_enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  keyvault_enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment
  keyvault_purge_protection_enabled        = var.keyvault_purge_protection_enabled
}

module "aks" {
  source              = "./modules/resource_templates/aks"
  aks_name            = local.aks_name
  resource_group_name = module.resource_group.resource_group_name
  depends_on          = [module.resource_group]
}
