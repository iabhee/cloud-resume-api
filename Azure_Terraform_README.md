# Terraform Modules for Azure Resources

This project deploys a set of Azure resources using Terraform modules. The setup includes resource groups, Cosmos DB, storage accounts, application insights, and Azure Functions.

## Prerequisites

- **Terraform**: Ensure Terraform is installed on your system. [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **Azure CLI**: Authenticate your Terraform scripts with Azure. [Installation Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- **Azure Subscription**: Required to deploy resources.

## Modules Overview

### 1. **Resource Group**
Manages the Azure Resource Group for all other resources.
```hcl
module "azure_resource_group" {
  source              = "./modules/azure_resource_group"
  resource_group_name = "${local.name}-rsg"
  location            = local.location
  tags                = local.tags
}
```
- **Inputs**:
  - `resource_group_name`: Name of the resource group.
  - `location`: Azure region.
  - `tags`: Metadata tags.

### 2. **Azure Cosmos DB**
Manages the Cosmos DB instance, database, and container.
```hcl
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
```
- **Inputs**:
  - `cosmosdb_account_name`, `cosmosdb_database_name`, `cosmosdb_container_name`
  - `partition_key_paths`: Partition key paths.
  - `indexing_policy`: Custom indexing policies.

### 3. **Azure Storage Account**
Creates a storage account for data storage needs.
```hcl
module "azure_storage_account" {
  source                   = "./modules/azure_storage_account"
  resource_group_name      = module.azure_resource_group.resource_group_name
  location                 = module.azure_resource_group.resource_group_location
  storage_account_name     = "${local.name}22storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}
```
- **Inputs**:
  - `storage_account_name`: Name of the storage account.
  - `account_tier`: Pricing tier (e.g., Standard).
  - `account_replication_type`: Replication type (e.g., LRS).

### 4. **Azure Application Insights**
Enables monitoring for Azure Functions.
```hcl
module "azure_application_insights" {
  source              = "./modules/azure_application_insights"
  function_app_name   = "${local.name}-function-app"
  resource_group_name = module.azure_resource_group.resource_group_name
  location            = module.azure_resource_group.resource_group_location
  tags                = local.tags
}
```
- **Inputs**:
  - `function_app_name`: Name of the Azure Function App.
  - `resource_group_name`, `location`

### 5. **Azure Functions**
Deploys a serverless Azure Function with integration to Cosmos DB and Application Insights.
```hcl
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
    "COSMOS_DB_ENDPOINT"             = module.azure_cosmosDB.cosmosdb_endpoint
    "COSMOS_DB_DATABASE"             = module.azure_cosmosDB.cosmosdb_database_name
    "COSMOS_DB_CONTAINER"            = module.azure_cosmosDB.cosmosdb_container_name    
    "COSMOS_DB_KEY"                  = module.azure_cosmosDB.cosmosdb_primary_master_key
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.azure_application_insights.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
  }

  depends_on = [
    module.azure_storage_account,
    module.azure_cosmosDB,
    module.azure_application_insights
  ]
}
```
- **Inputs**:
  - `function_app_name`, `os_type`, `service_plan_sku`
  - `app_settings`: Application-specific settings.

## How to Use
1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Validate configuration:
   ```bash
   terraform validate
   ```

3. Plan the infrastructure:
   ```bash
   terraform plan"
   ```

4. Deploy the infrastructure:
   ```bash
   terraform apply"
   ```

5. Destroy the infrastructure (if needed):
   ```bash
   terraform destroy"
   ```

## Notes
- Ensure the `local.name`, `local.location`, and `local.tags` variables are defined in your Terraform configuration.
- Customize module configurations to match your requirements.

