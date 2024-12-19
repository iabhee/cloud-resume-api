variable "cosmosdb_account_name" {
  description = "Name of CosmosDB Account"
  type        = string
}

variable "cosmosdb_database_name" {
  description = "Name of CosmosDB Database"
  type        = string
}

variable "cosmosdb_container_name" {
  description = "Name of CosmosDB Container"
  type        = string
}

variable "location" {
  description = "Location of the CosmosDB Account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource Group"
  type        = string
}

# currently offer_type only accepts "Standard"
variable "offer_type" {
  description = "Specify the Offer Type to use for this CosmosDB Account"
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Specify the Kind of CosmosDB to create - possible values GlobalDocumentDB, MongoDB, and Parse"
  type        = string
  default     = "GlobalDocumentDB"
}

variable "throughput" {
  description = "Define throughput"
  type        = string
  default     = null
}

variable "partition_key_paths" {
  description = "Partition key path"
  type        = list(string)
  default     = null
}

variable "partition_key_version" {
  description = "Partition key version"
  type        = string
  default     = null
}

variable "indexing_policy" {
  type = object({
    indexing_mode  = string
    included_paths = list(string)
    excluded_paths = list(string)
  })
  default = {
    indexing_mode  = "consistent"
    included_paths = []
    excluded_paths = []
  }
}