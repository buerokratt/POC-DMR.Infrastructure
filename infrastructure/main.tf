locals {
  project_name_short = "byk"
  environment        = "${var.environment_name}${var.environment_postfix}"
  primary_location   = var.primary_region
  secondary_location = var.secondary_region

  # Example: byk-dev-rg
  resource_group_name = "${local.project_name_short}-${local.environment}-rg"

  # Example: byk-dev-kv
  keyvault_name = "${local.project_name_short}-${local.environment}-kv"
  keyvault_sku  = "standard"

  # Example: byk-dev-aks
  aks_name = "${local.project_name_short}-${local.environment}-aks"

  traffic_manager_name = "${local.project_name_short}-${local.environment}-tm"

  cosmosdb_name = "${local.project_name_short}-${local.environment}-cosmos-db"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = local.primary_location
}

module "aks" {
  source = "./modules/aks"
  name   = local.aks_name
  resource_group = {
    location = local.primary_location
    name     = azurerm_resource_group.resource_group.name
  }
  keyvault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}

module "traffic_manager" {
  source                      = "./modules/traffic_manager"
  name                        = local.traffic_manager_name
  resource_group_name         = azurerm_resource_group.resource_group.name
  environment_name            = local.environment
  aks_pip_id                  = module.aks.ingress_pip_id
  aks_ingress_health_endpoint = module.aks.ingress_health_endpoint

  depends_on = [
    module.aks,
    azurerm_resource_group.resource_group
  ]
}
