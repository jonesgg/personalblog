#!/bin/bash

# Script to create a portfolio item
# Usage: ./create-portfolio.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "💼 Creating portfolio item..."

# Sample portfolio data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "portfolio-$(date +%s)",
  "slug": "my-test-portfolio",
  "title": "Test Portfolio Project",
  "content": [
    {"title": "Project Overview"},
    {"paragraph": "This is a description of my portfolio project."},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/51533ab9-ffdb-4a87-9af5-668acbdbda10.jpg"},
    {"paragraph": "Here's more information about the project."}
  ]
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/portfolio" \
    -H "Content-Type: application/json" \
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

