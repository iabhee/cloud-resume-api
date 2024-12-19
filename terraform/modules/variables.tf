variable "location" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "service_plan_name" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
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

variable "resource_group_name_location" {
  type = string
}