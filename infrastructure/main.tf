locals {
  project_name_short = "byk"
  environment        = "${var.environment_name}${var.environment_postfix}"
  primary_location   = "westeurope"

  # Example: byk-dev-rg
  resource_group_name = "${local.project_name_short}-${local.environment}-rg"

  # Example: bykdevstg
  storage_account_name = "${local.project_name_short}${local.environment}stg"

  # Example: byk-dev-kv
  keyvault_name = "${local.project_name_short}-${local.environment}-kv"

  # Example: byk-dev-aks
  aks_name = "${local.project_name_short}-${local.environment}-aks"

  traffic_manager_name = "${local.project_name_short}-${local.environment}-tm"
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = local.primary_location
}

module "key_vault" {
  source                          = "./modules/key_vault"
  resource_group_name             = module.resource_group.resource_group_name
  name                            = local.keyvault_name
  location                        = local.primary_location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment
  purge_protection_enabled        = var.keyvault_purge_protection_enabled
}

module "aks" {
  source              = "./modules/aks"
  name                = local.aks_name
  resource_group_name = module.resource_group.resource_group_name
  depends_on          = [module.resource_group]

  providers = {
    kubectl = kubectl.aks
  }
}

module "traffic_manager" {
  source              = "./modules/traffic_manager"
  name                = local.traffic_manager_name
  resource_group_name = module.resource_group.resource_group_name
  environment_name    = local.environment
  aks_pip = {
    name                = module.aks.aks_pip.name
    resource_group_name = module.aks.aks_pip.resource_group_name
  }

  depends_on = [
    module.resource_group,
    module.aks
  ]
}
