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


variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}


# variable "resource_group_name_location" {
#   type = string
# }