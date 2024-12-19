variable "location" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  type = string
}

variable "service_plan_sku" {
  type = string
}
variable "function_app_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "app_settings" {
  type        = map(string)
  description = "App settings for the Azure Function App"
  sensitive   = true
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type = string
}
variable "storage_account_connection_string" {
  description = "Storage Connection String"
  type        = string
}

variable "cosmosdb_endpoint" {
  type = string
}

variable "cosmosdb_database_name" {
  type = string
}

variable "cosmosdb_container_name" {
  type = string
}

variable "site_config" {
  description = "Site configuration for the function app"
  type        = object({})
  default     = {}
}

