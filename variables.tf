variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "mycompany"
}

variable "instance" {
  description = "Instance identifier (e.g., 001, 002)"
  type        = string
  default     = "001"
}

variable "environment" {
  description = "Environment (dev, staging, prod) - defaults to terraform workspace"
  type        = string
  default     = ""
}

# Local to determine environment from workspace or variable
locals {
  environment = terraform.workspace
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "australiaeast"
}

variable "project_name" {
  description = "Name of the project for tagging"
  type        = string
  default     = "Databricks Infrastructure"
}

variable "databricks_sku" {
  description = "SKU for Databricks workspace"
  type        = string
  default     = "premium"
  validation {
    condition     = contains(["standard", "premium", "trial"], var.databricks_sku)
    error_message = "Databricks SKU must be one of: standard, premium, trial."
  }
}

# Azure Authentication Variables
variable "azure_client_id" {
  description = "Azure Client ID for authentication"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure Client Secret for authentication"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID for authentication"
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}
