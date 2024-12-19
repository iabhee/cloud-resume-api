resource "azurerm_application_insights" "app_insights" {
  name                = "${var.function_app_name}-appinsights"
  application_type    = "Node.JS"
  location            = var.location
  resource_group_name = var.resource_group_name
}
