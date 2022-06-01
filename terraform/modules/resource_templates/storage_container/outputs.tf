output "id" {
  description = "Specifies the Id of the storage container created."
  value       = azurerm_storage_container.storage_container.id
}

output "name" {
  description = "Specifies the name of the storage container created."
  value       = azurerm_storage_container.storage_container.name
}