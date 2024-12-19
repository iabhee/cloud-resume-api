module "azure_resource_group" {
  source              = "./modules/azure_resource_group"
  resource_group_name = "${local.name}-rsg"
  location            = local.location
  tags                = local.tags
}

module "azure_cosmosDB" {
  source                  = "./modules/azure_cosmosDB"
  cosmosdb_account_name   = "${local.name}-cosmosdb"
  cosmosdb_database_name  = "${local.name}-db"
  cosmosdb_container_name = "${local.name}-container"
  location                = "Canada Central"
  resource_group_name     = module.azure_resource_group.resource_group_name
  partition_key_paths     = ["/id"]
  partition_key_version   = 1
  indexing_policy = {
    indexing_mode = "consistent"
    included_paths = [
      "/*"
    ]
    excluded_paths = [
      "/excluded/?"
    ]
  }
}

module "azure_storage_account" {
  source                   = "./modules/azure_storage_account"
  resource_group_name      = module.azure_resource_group.resource_group_name
  location                 = module.azure_resource_group.resource_group_location
  storage_account_name     = "${local.name}22storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags

}

module "azure_application_insights" {
  source              = "./modules/azure_application_insights"
  function_app_name   = "${local.name}-function-app"
  resource_group_name = module.azure_resource_group.resource_group_name
  location            = module.azure_resource_group.resource_group_location
  tags                = local.tags


}
module "azure_functions" {
  source                     = "./modules/azure_functions"
  location                   = "Canada Central"
  resource_group_name        = module.azure_resource_group.resource_group_name
  function_app_name          = "${local.name}-function-app"
  os_type                    = "Linux"
  storage_account_name       = module.azure_storage_account.storage_account_name
  storage_account_access_key = module.azure_storage_account.storage_account_access_key
  service_plan_sku           = "B1"
  tags                       = local.tags
  
  cosmosdb_endpoint                 = module.azure_cosmosDB.cosmosdb_endpoint
  cosmosdb_database_name            = module.azure_cosmosDB.cosmosdb_database_name
  cosmosdb_container_name           = module.azure_cosmosDB.cosmosdb_container_name
  storage_account_connection_string = module.azure_storage_account.storage_account_connection_string
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "node"
    "ENABLE_ORYX_BUILD"              = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
    "AzureWebJobsStorage"            = module.azure_storage_account.storage_account_connection_string
    "AzureWebJobsDisableHomepage"    = "true"
    "COSMOS_DB_ENDPOINT"             = module.azure_cosmosDB.cosmosdb_endpoint
    "COSMOS_DB_DATABASE"                 = module.azure_cosmosDB.cosmosdb_database_name
    "COSMOS_DB_CONTAINER"               = module.azure_cosmosDB.cosmosdb_container_name    
    "COSMOS_DB_KEY"                  = module.azure_cosmosDB.cosmosdb_primary_master_key
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.azure_application_insights.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
  }
  # Explicit dependency declaration
  depends_on = [
    module.azure_storage_account,
    module.azure_cosmosDB,
    module.azure_application_insights
  ]
}

