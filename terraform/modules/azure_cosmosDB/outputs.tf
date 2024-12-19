output "endpoint" {
  value       = azurerm_cosmosdb_account.db.endpoint
  description = "The Endpoint used to connect to CosmosDB Account "
}

output "cosmosdb_endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = azurerm_cosmosdb_account.db.endpoint
}

output "cosmosdb_primary_master_key" {
  description = "The Primary master key for the CosmosDB Account."
  value       = azurerm_cosmosdb_account.db.primary_key
  sensitive   = true
}

output "account_name" {
  value       = azurerm_cosmosdb_account.db.name
  description = "The name of CosmosDB Account"
}

output "account_id" {
  value       = azurerm_cosmosdb_account.db.id
  description = "The ID of CosmosDB Account"
}


output "cosmosdb_database_name" {
  value = azurerm_cosmosdb_sql_database.database_name.name
}

output "cosmosdb_container_name" {
  value = azurerm_cosmosdb_sql_container.db_container.name
}
