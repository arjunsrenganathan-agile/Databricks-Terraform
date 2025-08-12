variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "is_hns_enabled" {
  description = "Enable hierarchical namespace (Data Lake Gen2)"
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Name of the storage container"
  type        = string
  default     = "unity-catalog"
}

variable "container_access_type" {
  description = "Access type for the storage container"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "Tags to apply to the storage resources"
  type        = map(string)
  default     = {}
}
