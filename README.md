# Simple Databricks Terraform Infrastructure

A simple, production-ready Terraform configuration that creates Azure Databricks workspace and storage infrastructure with proper naming conventions.

## What This Creates

✅ **Azure Resource Group**  
✅ **Azure Databricks Workspace** (Premium SKU)  
✅ **Azure Storage Account** (Data Lake Gen2 enabled)  
✅ **Storage Container** (ready for future Unity Catalog setup)  

## Modular Architecture

This project uses a **modular architecture** for clean, reusable, and maintainable code:

### 🏗️ **Databricks Module** (`modules/databricks/`)
- Creates Azure Databricks workspace
- Configurable SKU (standard, premium, trial)
- Flexible tagging support
- Reusable across environments

### 📦 **Storage Module** (`modules/storage/`)
- Creates Azure Storage Account with Data Lake Gen2
- Creates Unity Catalog container
- Configurable replication and access settings
- Ready for Unity Catalog integration

### 🎯 **Root Module** (`main.tf`)
- Creates resource group (shared dependency)
- Orchestrates module calls
- Manages environment-specific configurations
- Handles naming conventions consistently

**Benefits:**
- ✅ **Clean separation of concerns**
- ✅ **Reusable components**
- ✅ **Easier testing and maintenance**
- ✅ **Consistent resource creation**  

## Naming Convention

Resources follow the pattern: `{prefix}-{instance}-{environment}-{resource-type}`

**Examples:**
- **Development**: 
  - Resource Group: `contoso-001-dev-rg`
  - Databricks: `contoso-001-dev-databricks`
  - Storage: `contoso001devstorage`
- **Production**: 
  - Resource Group: `contoso-001-prod-rg`
  - Databricks: `contoso-001-prod-databricks`
  - Storage: `contoso001prodstorage`

## Project Structure

```
.
├── main.tf                     # Main infrastructure configuration (uses modules)
├── providers.tf                # Provider configurations (Azure + Databricks)
├── variables.tf                # Variable definitions with workspace support
├── outputs.tf                  # Output definitions
├── modules/                    # Reusable Terraform modules
│   ├── databricks/             # Databricks workspace module
│   │   ├── main.tf             # Databricks workspace resource
│   │   ├── variables.tf        # Module input variables
│   │   └── outputs.tf          # Module outputs
│   └── storage/                # Storage account module
│       ├── main.tf             # Storage account and container resources
│       ├── variables.tf        # Module input variables
│       └── outputs.tf          # Module outputs
├── terraform.tfvars.dev        # Development environment config
├── terraform.tfvars.staging    # Staging environment config
├── terraform.tfvars.prod       # Production environment config
├── terraform.tfvars.example    # Example variables file
├── manage-workspace.sh         # Workspace management helper script
├── .env.example                # Example environment variables
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## Environment Management with Terraform Workspaces

This project uses **Terraform Workspaces** to manage multiple environments (dev, staging, prod) with the same codebase.

### Quick Start with Workspaces

```bash
# Development environment
./manage-workspace.sh dev plan
./manage-workspace.sh dev apply

# Staging environment  
./manage-workspace.sh staging plan
./manage-workspace.sh staging apply

# Production environment
./manage-workspace.sh prod plan
./manage-workspace.sh prod apply

# Destroy environments when no longer needed
./manage-workspace.sh dev destroy
./manage-workspace.sh staging destroy
./manage-workspace.sh prod destroy
```

## Setup Instructions

### 1. Login to Azure CLI

```bash
az login
az account set --subscription "your-subscription-name-or-id"
DEFAULT_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
```

### 2. Create a Service Principal

**If you encounter "non compliant device" errors, use one of these alternatives:**

#### Option A: Use Azure Portal (Recommended for compliant device issues)
1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** > **App registrations** > **New registration**
3. Name: `terraform-databricks`
4. After creation, go to **Certificates & secrets** > **New client secret**
5. Copy the secret value immediately (you won't see it again)
6. Go to **Subscriptions** > Your subscription > **Access control (IAM)** > **Add role assignment**
7. Role: `Contributor`, Assign to: your new app registration

#### Option B: Command Line (if device is compliant)
```bash
# Create service principal
az ad sp create-for-rbac --name "terraform-databricks-sp" --role Contributor --scopes /subscriptions/$DEFAULT_SUBSCRIPTION_ID
```

#### Option C: Use existing credentials from environment
If your organization provides service principal credentials, skip creation and use those directly.

**Expected output format:**
```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "terraform-databricks",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

**🔐 Permission Levels Explained:**
- **Azure Subscription**: Service principal gets `Contributor` role (for Azure resources)
- **Databricks Workspace**: Automatic access to workspace APIs  
- **Databricks Account**: Requires separate account admin privileges (for Unity Catalog)

**Current Setup**: Covers Azure + Databricks workspace level ✅  
**Unity Catalog**: Requires additional account-level permissions ⚠️

### 3. Configure Environment Variables

```bash
# Copy and edit environment variables
cp .env.example .env

# Edit .env with your service principal details
# ARM_CLIENT_ID = appId from above
# ARM_CLIENT_SECRET = password from above  
# ARM_TENANT_ID = tenant from above
# ARM_SUBSCRIPTION_ID = your subscription ID
```

### 4. Deploy to Environments

Environment configuration is automatically handled through Terraform workspaces and environment-specific variable files.

#### Option A: Using the Helper Script (Recommended)
```bash
# Load environment variables
source .env

# Development
./manage-workspace.sh dev plan     # Review changes
./manage-workspace.sh dev apply    # Deploy

# Staging
./manage-workspace.sh staging apply

# Production
./manage-workspace.sh prod apply

# Destroy environments (with confirmation prompt)
./manage-workspace.sh dev destroy
./manage-workspace.sh staging destroy
./manage-workspace.sh prod destroy
```

#### Option B: Manual Terraform Commands
```bash
# Load environment variables
source .env

# Create/switch to development workspace
terraform workspace new dev  # or: terraform workspace select dev
terraform plan -var-file="terraform.tfvars.dev"
terraform apply -var-file="terraform.tfvars.dev"

# Switch to production workspace
terraform workspace select prod
terraform apply -var-file="terraform.tfvars.prod"
```

### 5. Deploy Infrastructure

```bash
# Load environment variables
source .env

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## What Gets Created

After successful deployment, you'll have:

1. **Resource Group**: `{prefix}-{instance}-{workspace}-rg`
2. **Databricks Workspace**: `{prefix}-{instance}-{workspace}-databricks`
3. **Storage Account**: `{prefix}{instance}{workspace}storage` 
4. **Storage Container**: `unity-catalog` (ready for future Unity Catalog setup)

**Example Outputs by Environment:**

**Development (workspace: dev):**
```
databricks_workspace_name = "contoso-001-dev-databricks"
storage_account_name = "contoso001devstorage"
```

**Staging (workspace: staging):**
```
databricks_workspace_name = "contoso-001-staging-databricks"
storage_account_name = "contoso001stagingstorage"
```

**Production (workspace: prod):**
```
databricks_workspace_name = "contoso-001-prod-databricks"
storage_account_name = "contoso001prodstorage"
```

## Workspace Management

### Available Commands
```bash
# View current workspace
terraform workspace show

# List all workspaces
terraform workspace list

# Create new workspace
terraform workspace new <environment>

# Switch workspace
terraform workspace select <environment>

# Delete workspace (must be empty)
terraform workspace delete <environment>
```

### Environment Configurations

Each environment has its own configuration file:

### Development Environment
```hcl
# In terraform.tfvars
prefix = "contoso"
environment = "dev"
databricks_sku = "standard"
```

**Creates:**
- Resource Group: `contoso-001-dev-rg`
- Databricks: `contoso-001-dev-databricks`
- Storage: `contoso001devstorage`

### Production Environment
```hcl
# In terraform.tfvars
prefix = "contoso"
environment = "prod"
databricks_sku = "premium"
```

**Creates:**
- Resource Group: `contoso-001-prod-rg`
- Databricks: `contoso-001-prod-databricks`
- Storage: `contoso001prodstorage`

## Next Steps

1. **Access your Databricks workspace** using the URL from terraform output
2. **Create clusters** and start developing notebooks
3. **Use the storage account** for your data lake needs
4. **Future Unity Catalog setup** when metastore is configured

## What's Not Included (Yet)

### Unity Catalog
Unity Catalog requires **account-level permissions** which are different from workspace-level permissions:

**Why Unity Catalog Failed:**
- Current service principal has **workspace-level** permissions (Contributor on Azure subscription)
- Unity Catalog operations require **account-level** permissions in Databricks
- Metastore creation/management needs account admin privileges

**To Enable Unity Catalog Later:**
1. **Account Admin Access**: Service principal needs to be added as account admin in Databricks
2. **Account-Level Authentication**: Configure Databricks provider with account host
3. **Metastore Setup**: Create metastore with proper storage root configuration
4. **External Locations**: Register storage locations for catalog use

**Current Workaround:**
- Storage account is ready for Unity Catalog
- Can be configured manually through Databricks UI by account admin
- Or upgrade service principal permissions for automated setup

### Other Future Additions
- Virtual networks (can be added as needed)
- Private endpoints (for enhanced security)
- Key Vault integration (for secrets management)

## Troubleshooting

### Unity Catalog Permission Issues
**Error**: `cannot create metastore` or `invalid Databricks Account configuration`

**Root Cause**: Service principal lacks account-level permissions

**Solution Options:**
1. **Account Admin Access**: Have Databricks account admin add SP to account
2. **Manual Setup**: Use Databricks UI to configure Unity Catalog manually  
3. **Upgrade Permissions**: Request account-level access for automation

**Current Status**: Infrastructure ready, Unity Catalog requires admin intervention

### "Non Compliant Device" Error
This error occurs when your organization has conditional access policies requiring device compliance:

```
AADSTS53000: Device is not in required device state: compliant
```

**Solutions:**
1. **Use Azure Portal** (Option A above) - Most reliable method
2. **Contact IT Admin** - Ask them to create the service principal
3. **Use Compliant Device** - If available, use a company-managed device
4. **Request Exception** - Ask IT for temporary conditional access bypass

### Authentication Issues
If you get authentication errors during `terraform apply`:
1. Verify `.env` file has correct values
2. Check that `source .env` was run
3. Verify service principal has Contributor role on subscription

### Infrastructure Issues
If resources fail to create:
1. Check Azure subscription limits
2. Verify region availability (currently set to australiaeast)
3. Ensure unique naming (storage account names must be globally unique)

## Security Notes

- Never commit `.env` or `terraform.tfvars` files to git
- Store service principal credentials securely
- Use separate service principals for different environments
- Consider using Azure Key Vault for production secrets

## Cleanup

### Option A: Using the Helper Script (Recommended)
```bash
# Destroy specific environment with confirmation
./manage-workspace.sh dev destroy
./manage-workspace.sh staging destroy
./manage-workspace.sh prod destroy
```

The script will:
1. Switch to the correct workspace
2. Ask for confirmation before destroying
3. Run `terraform destroy` with the environment-specific variables

### Option B: Manual Terraform Commands
```bash
# Load environment variables
source .env

# Switch to the workspace you want to destroy
terraform workspace select dev

# Destroy with environment-specific variables
terraform destroy -var-file="terraform.tfvars.dev"
```

**⚠️ Warning**: Destroy operations are irreversible. Always verify you're in the correct workspace and environment before confirming.

## Contributing

This is a foundation that can be extended with:
- Additional storage accounts
- Key Vault integration
- Virtual networking
- Unity Catalog (when metastore is configured)
- CI/CD pipeline integration
