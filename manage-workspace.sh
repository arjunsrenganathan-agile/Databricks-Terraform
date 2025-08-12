#!/bin/bash

# Terraform Workspace Management Script
# Usage: ./manage-workspace.sh [dev|staging|prod] [plan|apply|destroy]

set -e

ENVIRONMENT=$1
ACTION=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$ACTION" ]; then
    echo "Usage: $0 [dev|staging|prod] [plan|apply|destroy]"
    echo ""
    echo "Examples:"
    echo "  $0 dev plan       # Plan development environment"
    echo "  $0 prod apply     # Apply production environment"
    echo "  $0 staging destroy # Destroy staging environment"
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "Error: Environment must be dev, staging, or prod"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
    echo "Error: Action must be plan, apply, or destroy"
    exit 1
fi

echo "🚀 Managing Terraform workspace: $ENVIRONMENT"
echo "📋 Action: $ACTION"
echo ""

# Load environment variables
if [ -f .env ]; then
    echo "📦 Loading environment variables from .env"
    source .env
else
    echo "⚠️  Warning: .env file not found"
fi

# Create or select workspace
echo "🔧 Setting up Terraform workspace: $ENVIRONMENT"
terraform workspace select $ENVIRONMENT 2>/dev/null || terraform workspace new $ENVIRONMENT

# Show current workspace
echo "✅ Current workspace: $(terraform workspace show)"
echo ""

# Run the action with environment-specific vars
case $ACTION in
    plan)
        echo "📊 Planning infrastructure for $ENVIRONMENT..."
        terraform plan -var-file="terraform.tfvars.$ENVIRONMENT"
        ;;
    apply)
        echo "🏗️  Applying infrastructure for $ENVIRONMENT..."
        terraform apply -var-file="terraform.tfvars.$ENVIRONMENT"
        ;;
    destroy)
        echo "💥 Destroying infrastructure for $ENVIRONMENT..."
        echo "⚠️  This will destroy all resources in $ENVIRONMENT!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform destroy -var-file="terraform.tfvars.$ENVIRONMENT"
        else
            echo "❌ Destroy cancelled"
            exit 1
        fi
        ;;
esac

echo ""
echo "✅ Completed $ACTION for $ENVIRONMENT environment"
