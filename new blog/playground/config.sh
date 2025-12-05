#!/bin/bash

# Configuration file for API testing scripts
# Set your API Gateway URL here or export it as an environment variable

# Get API URL from environment variable or set default
# You can get this from: cd terraform && terraform output -raw api_gateway_url
# Note: API Gateway HTTP API v2 requires the stage name in the URL path
# The stage name is "dev" by default (from terraform variables)
export API_BASE_URL="${API_BASE_URL:-https://0sjwzpf8e0.execute-api.us-east-1.amazonaws.com/dev}"

# Admin token for authentication (plain token, not the bcrypt hash)
# This is the plain token you saved when running generate-secret-token.py --show-plain
# Set it as an environment variable: export ADMIN_TOKEN="your-plain-token-here"
# Or uncomment and set it directly below:
# ADMIN_TOKEN="your-plain-token-here"
export ADMIN_TOKEN="${ADMIN_TOKEN:-}"

# Images directory
export IMAGES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/images"

