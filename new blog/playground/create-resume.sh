#!/bin/bash

# Script to create a resume item
# Usage: ./create-resume.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "📄 Creating resume item..."

# Check if admin token is set
if [ -z "${ADMIN_TOKEN}" ]; then
    echo "❌ Error: ADMIN_TOKEN is not set"
    echo "Please set it in config.sh or export it as an environment variable:"
    echo "  export ADMIN_TOKEN=\"your-plain-token-here\""
    exit 1
fi

# Sample resume data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "resume-$(date +%s)",
  "title": "test resume",
  "company_name": "test company",
  "image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/3afcaa42-b8b3-4e58-9523-26f60164c99e.png",
  "start_month": "2025-01",
  "end_month": "2025-04",
  "description": "test description"
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/resume" \
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
    echo "✅ Resume item created successfully!"
else
    echo ""
    echo "❌ Creation failed"
    exit 1
fi

