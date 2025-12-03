#!/bin/bash

# Script to get a portfolio item by slug
# Usage: ./get-portfolio.sh <slug>
# Example: ./get-portfolio.sh my-test-portfolio-1234567890

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <slug>"
    echo "Example: $0 my-test-portfolio-1234567890"
    exit 1
fi

SLUG="$1"

echo "💼 Getting portfolio item: ${SLUG}"

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
    "${API_BASE_URL}/portfolio/${SLUG}")

# Extract HTTP status code (last line)
HTTP_CODE=$(echo "${RESPONSE}" | tail -n1)
BODY=$(echo "${RESPONSE}" | sed '$d')

# Print response
echo ""
echo "Status Code: ${HTTP_CODE}"
echo "Response:"
echo "${BODY}" | python3 -m json.tool 2>/dev/null || echo "${BODY}"

if [ "${HTTP_CODE}" -eq 200 ]; then
    echo ""
    echo "✅ Portfolio item retrieved successfully!"
else
    echo ""
    echo "❌ Retrieval failed"
    exit 1
fi

