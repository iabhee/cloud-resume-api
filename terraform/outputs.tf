# # Output from Azure Functions module
output "function_app_name" {
  value       = module.azure_functions.function_app_name
  description = "Name of the Azure Function App"
}

output "function_app_url" {
  value       = module.azure_functions.function_app_url
  description = "The URL of the Azure Function App"
}

# # Output from Storage Module
output "storage_account_name" {
  value       = module.azure_storage_account.storage_account_name
  description = "Name of Storage Account"
}
output "storage_account_access_key" {
  value       = module.azure_storage_account.storage_account_access_key
  sensitive   = true
  description = "Connection String for Storage Account"
}
# # Output from CosmosDB module

output "cosmos_db_account_name" {
  value       = module.azure_cosmosDB.cosmosdb_database_name
  description = "The name of CosmosDB Account"
}

output "cosmos_db_database_name" {
  value       = module.azure_cosmosDB.cosmosdb_database_name
  description = "Name of CosmosDB SQL Database"
}

output "cosmos_db_container_name" {
  value       = module.azure_cosmosDB.cosmosdb_container_name
  description = "Name of CosmosDB Database Container"
}

output "cosmosdb_endpoint" {
  value       = module.azure_cosmosDB.cosmosdb_endpoint
  description = "Name of CosmosDB Database Container"
}
