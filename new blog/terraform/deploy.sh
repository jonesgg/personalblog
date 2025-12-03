#!/bin/bash

# Script to package Lambda functions and deploy with Terraform
# Run this from the terraform directory

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure we're in the terraform directory
cd "${SCRIPT_DIR}"

echo "📦 Step 1: Packaging Lambda functions..."
"${SCRIPT_DIR}/package-lambdas.sh"

echo ""
echo "🏗️  Step 2: Initializing Terraform..."
# Always run init with -upgrade to ensure lock file is properly generated/updated
# This fixes issues with missing or corrupted lock files
echo "🔧 Running terraform init -upgrade..."
terraform init -upgrade

echo ""
echo "🚀 Step 3: Planning Terraform configuration..."
terraform plan "$@"

echo ""
echo "✅ Plan complete!"

