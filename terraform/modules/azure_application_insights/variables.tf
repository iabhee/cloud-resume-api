variable "location" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  type = string
}

variable "function_app_name" {
  type = string
}