# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  # Authentication will be handled by GitHub Actions environment variables
}

# Configure the Databricks provider using Azure authentication
provider "databricks" {
  host = azurerm_databricks_workspace.databricks.workspace_url
  # Authentication will be handled by GitHub Actions environment variables
}
