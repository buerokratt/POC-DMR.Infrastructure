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

resource "random_password" "dmr_participant_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "dmr_participant_key" {
  name         = "DmrCentOpsApiKey"
  value        = random_password.dmr_participant_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

#
# Generate CentOps API Key for the Mock Classifier
#

resource "random_password" "mockclassifier_participant_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockclassifer_participant_key" {
  name         = "MockClassifierCentOpsApiKey"
  value        = random_password.mockclassifier_participant_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

#
# Generate CentOps API Key for the Mock Bots
#

# MockBot1

resource "random_password" "mockbot1_participant_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot1_participant_key" {
  name         = "MockBot1CentOpsApiKey"
  value        = random_password.mockbot1_participant_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

resource "random_password" "mockbot1_chatapi_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot1_chatapi_key" {
  name         = "MockBot1CentOpsApiKey"
  value        = random_password.mockbot1_chatapi_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

# MockBot2
resource "random_password" "mockbot2_participant_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot2_participant_key" {
  name         = "MockBot2CentOpsApiKey"
  value        = random_password.mockbot2_participant_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}

resource "random_password" "mockbot2_chatapi_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "/-="
}

resource "azurerm_key_vault_secret" "mockbot2_chatapi_key" {
  name         = "MockBot2ApiKey"
  value        = random_password.mockbot2_chatapi_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}