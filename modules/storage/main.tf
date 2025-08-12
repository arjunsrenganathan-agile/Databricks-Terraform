# Create storage account for Unity Catalog
resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  is_hns_enabled          = var.is_hns_enabled

  tags = var.tags
}

# Create container for Unity Catalog metastore
resource "azurerm_storage_container" "main" {
  name                 = var.container_name
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = var.container_access_type
}
