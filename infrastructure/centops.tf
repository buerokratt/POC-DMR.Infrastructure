resource "random_password" "centops_admin_key" {
  length           = 30
  lower            = true
  upper            = true
  override_special = "\\/-="
}

resource "azurerm_key_vault_secret" "centops_admin_key" {
  name         = "CentOpsAdminApiKey"
  value        = random_password.centops_admin_key.result
  key_vault_id = azurerm_key_vault_access_policy.deployer.key_vault_id
}
