# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.instance}-${local.environment}-rg"
  location = var.location

  tags = {
    Environment = local.environment
    Project     = var.project_name
    Instance    = var.instance
  }
}

# Create Databricks workspace using module
module "databricks" {
  source = "./modules/databricks"

  name                = "${var.prefix}-${var.instance}-${local.environment}-databricks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.databricks_sku

  tags = {
    Environment = local.environment
    Project     = var.project_name
    Instance    = var.instance
  }
}

# Create storage account using module
module "storage" {
  source = "./modules/storage"

  name                     = "${replace(var.prefix, "-", "")}${var.instance}${local.environment}storage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled          = true  # Required for Unity Catalog
  container_name          = "unity-catalog"
  container_access_type   = "private"

  tags = {
    Environment = local.environment
    Project     = var.project_name
    Instance    = var.instance
    Purpose     = "Unity Catalog"
  }
}

# Create Key Vault using module
module "keyvault" {
  source = "./modules/keyvault"

  name                = "${var.prefix}-${var.instance}-${local.environment}-kv"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  sku_name            = "standard"

  # Security settings
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false  # Allow purging for dev/test environments
  soft_delete_retention_days      = 7

  tags = {
    Environment = local.environment
    Project     = var.project_name
    Instance    = var.instance
    Purpose     = "Secrets Management"
  }
}

# Note: Unity Catalog creation requires additional metastore setup
# Will be added in future iterations once metastore is properly configured
