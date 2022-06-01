output "id" {
  description = "Specifies the Id of the storage account created."
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "Specifies the name of the storage account created."
  value       = azurerm_storage_account.storage_account.name
}