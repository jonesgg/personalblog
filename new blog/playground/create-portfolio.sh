#!/bin/bash

# Script to create a portfolio item
# Usage: ./create-portfolio.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "💼 Creating portfolio item..."

# Check if admin token is set
if [ -z "${ADMIN_TOKEN}" ]; then
    echo "❌ Error: ADMIN_TOKEN is not set"
    echo "Please set it in config.sh or export it as an environment variable:"
    echo "  export ADMIN_TOKEN=\"your-plain-token-here\""
    exit 1
fi

# Sample portfolio data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "portfolio-$(date +%s)",
  "slug": "react-spectrum-graph-library",
  "title": "React Spectrum Graph Library",
  "summary": "React Spectrum graph library for creating interactive graphs.",
  "content": [
    {"title": "My React Spectrum graph library"},
    {"paragraph": "React Spectrum graph library for creating interactive graphs. Built at Adobe."},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/4fe4e478-c60f-4f2d-b4c8-912cac404057.png"},
    {"paragraph": "It is built using TypeScript, React, and the Vega Visualization Grammar"}
  ]
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/portfolio" \
    -H "Content-Type: application/json" \
    -H "x-admin-token: ${ADMIN_TOKEN}" \
    -d "${JSON_PAYLOAD}")

# Extract HTTP status code (last line)
HTTP_CODE=$(echo "${RESPONSE}" | tail -n1)
BODY=$(echo "${RESPONSE}" | sed '$d')

# Print response
echo ""
echo "Status Code: ${HTTP_CODE}"
echo "Response:"
echo "${BODY}" | python3 -m json.tool 2>/dev/null || echo "${BODY}"

if [ "${HTTP_CODE}" -eq 201 ]; then
    echo ""
    echo "✅ Portfolio item created successfully!"
else
    echo ""
    echo "❌ Creation failed"
    exit 1
fi

