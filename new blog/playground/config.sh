#!/bin/bash

# Configuration file for API testing scripts
# Set your API Gateway URL here or export it as an environment variable

# Get API URL from environment variable or set default
# You can get this from: cd terraform && terraform output -raw api_gateway_url
# Note: API Gateway HTTP API v2 requires the stage name in the URL path
# The stage name is "dev" by default (from terraform variables)
export API_BASE_URL="${API_BASE_URL:-https://0sjwzpf8e0.execute-api.us-east-1.amazonaws.com/dev}"

# Images directory
export IMAGES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/images"

