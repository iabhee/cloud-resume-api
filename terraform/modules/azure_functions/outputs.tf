output "function_app_name" {
  value       = azurerm_linux_function_app.main.name
  description = "Name of the Function App"
}
output "function_app_url" {
  value       = azurerm_linux_function_app.main.default_hostname
  description = "The URL of the Azure Function App"
}