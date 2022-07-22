#
# Generate CentOps Admin Key
#

resource "random_password" "centops_admin_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "centops_admin_key" {
  name         = "CentOpsAdminApiKey"
  value        = random_password.centops_admin_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

#
# Generate CentOps API Key for the DMR
#

resource "random_password" "dmr_api_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "dmr_api_key" {
  name         = "DmrCentOpsApiKey"
  value        = random_password.dmr_api_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

#
# Generate CentOps API Key for the Mock Classifier
#

resource "random_password" "mockclassifier_api_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockclassifer_api_key" {
  name         = "MockClassifierCentOpsApiKey"
  value        = random_password.mockclassifier_api_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

#
# Generate CentOps API Key for the Mock Bot 
#

# MockBot1
resource "random_password" "mockbot1_api_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot1_api_key" {
  name         = "MockBot1CentOpsApiKey"
  value        = random_password.mockbot1_api_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

# MockBot2
resource "random_password" "mockbot2_api_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot2_api_key" {
  name         = "MockBot2CentOpsApiKey"
  value        = random_password.mockbot2_api_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}
