# Create Databricks workspace
resource "azurerm_databricks_workspace" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  tags = var.tags
}
