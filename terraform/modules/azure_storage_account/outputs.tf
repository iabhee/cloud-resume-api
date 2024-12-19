output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "storage_account_connection_string" {
  value       = azurerm_storage_account.main.primary_connection_string
  description = "Primary Connection String of Storage Account"
  sensitive   = true
}