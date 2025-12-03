#!/bin/bash

# Script to package all Lambda functions before Terraform deployment
# This script packages all Lambda functions with their dependencies
# Run this from the terraform directory

set -e  # Exit on error

# Get the script directory (terraform directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${PROJECT_ROOT}/src/lambda"
TEMP_DIR="${SCRIPT_DIR}/.terraform"

echo "🚀 Packaging Lambda functions..."

# Create temp directory if it doesn't exist
mkdir -p "${TEMP_DIR}"

# Function to package a Lambda function
package_lambda() {
    local function_name=$1
    local handler_path=$2
    local utils_path=$3
    
    echo "📦 Packaging ${function_name}..."
    
    local temp_dir="${TEMP_DIR}/${function_name}-temp"
    
    # Clean and create temp directory
    rm -rf "${temp_dir}"
    mkdir -p "${temp_dir}"
    
    # Copy handler files
    cp -r "${handler_path}"/* "${temp_dir}/"
    
    # Copy utils if they exist
    if [ -d "${utils_path}" ]; then
        cp -r "${utils_path}" "${temp_dir}/"
    fi
    
    # Create zip file
    cd "${temp_dir}"
    zip -r "${TEMP_DIR}/${function_name}.zip" . > /dev/null
    cd - > /dev/null
    
    echo "✅ ${function_name} packaged successfully"
}

# Package Blogpost functions
package_lambda "blogpost-create" \
    "${SRC_DIR}/blogpost/blogpost-create" \
    "${SRC_DIR}/blogpost/utils"

package_lambda "blogpost-get" \
    "${SRC_DIR}/blogpost/blogpost-get" \
    "${SRC_DIR}/blogpost/utils"

package_lambda "blogpost-list" \
    "${SRC_DIR}/blogpost/blogpost-list" \
    "${SRC_DIR}/blogpost/utils"

# Package Portfolio functions
package_lambda "portfolio-create" \
    "${SRC_DIR}/portfolio/portfolio-create" \
    "${SRC_DIR}/portfolio/utils"

package_lambda "portfolio-get" \
    "${SRC_DIR}/portfolio/portfolio-get" \
    "${SRC_DIR}/portfolio/utils"

package_lambda "portfolio-list" \
    "${SRC_DIR}/portfolio/portfolio-list" \
    "${SRC_DIR}/portfolio/utils"

# Package Resume functions
package_lambda "resume-create" \
    "${SRC_DIR}/resume/resume-create" \
    "${SRC_DIR}/resume/utils"

package_lambda "resume-list" \
    "${SRC_DIR}/resume/resume-list" \
    "${SRC_DIR}/resume/utils"

# Package Image functions
package_lambda "image-upload" \
    "${SRC_DIR}/image/image-upload" \
    "${SRC_DIR}/image/utils"

echo ""
echo "✨ All Lambda functions packaged successfully!"
echo "📁 Packages are in: ${TEMP_DIR}"
echo ""

