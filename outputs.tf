output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  value       = module.databricks.workspace_name
}

output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = module.databricks.workspace_url
}

output "databricks_workspace_id" {
  description = "ID of the Databricks workspace"
  value       = module.databricks.workspace_id
}

# Azure client configuration outputs (useful for debugging)
output "current_client_id" {
  description = "Client ID of the current Azure authentication"
  value       = data.azurerm_client_config.current.client_id
}

output "current_tenant_id" {
  description = "Tenant ID of the current Azure authentication"
  value       = data.azurerm_client_config.current.tenant_id
}

output "current_subscription_id" {
  description = "Subscription ID of the current Azure authentication"
  value       = data.azurerm_client_config.current.subscription_id
}

output "current_object_id" {
  description = "Object ID of the current Azure authentication"
  value       = data.azurerm_client_config.current.object_id
}

# Environment outputs
output "environment_used" {
  description = "Environment being used (from workspace or variable)"
  value       = local.environment
}

output "terraform_workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

# Storage account outputs
output "storage_account_name" {
  description = "Name of the Unity Catalog storage account"
  value       = module.storage.storage_account_name
}

output "storage_container_name" {
  description = "Name of the Unity Catalog storage container"
  value       = module.storage.container_name
}

output "storage_url" {
  description = "ABFSS URL for the Unity Catalog storage"
  value       = module.storage.storage_url
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.key_vault_uri
}
