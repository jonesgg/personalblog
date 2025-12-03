#!/bin/bash

# Script to create a resume item
# Usage: ./create-resume.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "📄 Creating resume item..."

# Sample resume data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "resume-$(date +%s)",
  "image_url": "https://example.com/company-logo.jpg",
  "start_month": "2024-01",
  "end_month": "2024-12",
  "description": "Software Engineer at Example Company. Worked on various projects and gained valuable experience."
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/resume" \
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
    echo "✅ Resume item created successfully!"
else
    echo ""
    echo "❌ Creation failed"
    exit 1
fi

