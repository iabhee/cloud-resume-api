
resource "azurerm_cosmosdb_account" "db" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind

  free_tier_enabled = "true"

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "database_name" {
  name                = var.cosmosdb_database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "db_container" {
  name                  = var.cosmosdb_container_name
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.db.name
  database_name         = azurerm_cosmosdb_sql_database.database_name.name
  partition_key_paths   = var.partition_key_paths
  partition_key_version = var.partition_key_version
  throughput            = var.throughput

  indexing_policy {
    indexing_mode = var.indexing_policy.indexing_mode

    dynamic "included_path" {
      for_each = var.indexing_policy.included_paths
      content {
        path = included_path.value
      }
    }

    dynamic "excluded_path" {
      for_each = var.indexing_policy.excluded_paths
      content {
        path = excluded_path.value
      }
    }
  }

}