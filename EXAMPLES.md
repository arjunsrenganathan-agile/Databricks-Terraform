# Example Deployment Commands

## Development Environment
```bash
# Copy and edit variables for dev
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars:
# environment = "dev"
# prefix = "mycompany" 
# instance = "001"

# Deploy
terraform init
terraform plan
terraform apply

# Resources created:
# - mycompany-001-dev-rg (Resource Group)
# - mycompany-001-dev-databricks (Databricks Workspace)
```

## Production Environment  
```bash
# Edit terraform.tfvars for production:
# environment = "prod"
# databricks_sku = "premium"

# Deploy
terraform plan
terraform apply

# Resources created:
# - mycompany-001-prod-rg (Resource Group)
# - mycompany-001-prod-databricks (Databricks Workspace)
```
