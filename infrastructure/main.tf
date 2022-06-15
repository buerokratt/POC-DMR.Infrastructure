locals {
  project_name       = "buerokratt"
  project_name_short = "byk"
  environment        = "${var.environment_name}${var.environment_postfix}"
  primary_location   = "westeurope"

  # Example: buerokratt-dev-rg
  resource_group_name = "${local.project_name_short}-${local.environment}-rg"

  # Example: bykdevstg
  storage_account_name = "${local.project_name_short}${local.environment}stg"

  # Example: byk-dev-kv
  keyvault_name = "${local.project_name_short}-${local.environment}-kv"

  # Example: byk-dev-aks
  aks_name = "${local.project_name_short}-${local.environment}-aks"

  public_ip_name = "${local.project_name_short}-${local.environment}-pip"

  traffic_manager_name          = "${local.project_name_short}-${local.environment}-traffic-manager"
  traffic_manager_endpoint_name = "${local.project_name_short}-${local.environment}-traffic-manager-endpoint"
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "./modules/resource_templates/resource_group"
  name     = local.resource_group_name
  location = local.primary_location
}

module "key_vault" {
  source                          = "./modules/resource_templates/key_vault"
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
  source              = "./modules/resource_templates/aks"
  name                = local.aks_name
  resource_group_name = module.resource_group.resource_group_name
  depends_on          = [module.resource_group]
}

module "traffic_manager" {
  source              = "./modules/resource_templates/traffic_manager"
  name                = local.traffic_manager_name
  resource_group_name = module.resource_group.resource_group_name
  public_ip_name      = local.public_ip_name
  endpoint_name       = local.traffic_manager_endpoint_name
  depends_on          = [module.resource_group]
}