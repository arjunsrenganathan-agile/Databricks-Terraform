output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_dfs_endpoint" {
  description = "Primary Data Lake Gen2 endpoint"
  value       = azurerm_storage_account.main.primary_dfs_endpoint
}

output "container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_container.main.name
}

output "storage_url" {
  description = "Full storage URL for Unity Catalog"
  value       = "abfss://${azurerm_storage_container.main.name}@${azurerm_storage_account.main.name}.dfs.core.windows.net/"
}
