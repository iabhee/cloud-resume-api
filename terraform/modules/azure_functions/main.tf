resource "azurerm_service_plan" "main" {
  name                = "${var.function_app_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.service_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_function_app" "main" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  service_plan_id            = azurerm_service_plan.main.id
  https_only                 = true
  app_settings               = var.app_settings

  site_config {
    cors {
      allowed_origins = ["*"]
    }
    application_stack {
      node_version = "20"
    }
    always_on = true
  }
  tags = var.tags
}

