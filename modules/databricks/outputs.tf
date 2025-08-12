output "workspace_name" {
  description = "Name of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.name
}

output "workspace_url" {
  description = "URL of the Databricks workspace"
  value       = "https://${azurerm_databricks_workspace.main.workspace_url}"
}

output "workspace_id" {
  description = "ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.workspace_id
}

output "workspace_url_raw" {
  description = "Raw workspace URL (without https://)"
  value       = azurerm_databricks_workspace.main.workspace_url
}
