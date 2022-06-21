resource "azurerm_cosmosdb_account" "cosmos" {
  name                = local.cosmosdb_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = local.primary_location
    failover_priority = 0
  }

  geo_location {
    location          = local.secondary_location
    failover_priority = 1
  }
}

resource "azurerm_key_vault_secret" "cosmoskey" {
  name         = "CosmosDbKey"
  value        = azurerm_cosmosdb_account.cosmos.primary_key
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_cosmosdb_sql_database" "centops" {
  name                = "centops"
  resource_group_name = azurerm_cosmosdb_account.cosmos.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  throughput          = var.cosmos_throughput
}

resource "azurerm_cosmosdb_sql_container" "participants" {
  name                = "participants"
  resource_group_name = azurerm_cosmosdb_sql_database.centops.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.centops.name
  partition_key_path    = "/pk"
  partition_key_version = 1

  # Currently, this container will use the whole budget set on database (see throughput value on the database resource)
  #   This value is optional but can only be set at creation of this container. So we're setting it to retain flexibility
  #   The minimum value is 400
  throughput            = var.cosmos_throughput

  indexing_policy {
    indexing_mode = "Consistent"
    included_path {
      path = "/*"
    }
  }
}
