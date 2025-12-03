#!/bin/bash

# Script to list all portfolio items
# Usage: ./list-portfolios.sh [sort] [order]
# Example: ./list-portfolios.sh title asc

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

SORT="${1:-title}"
ORDER="${2:-asc}"

echo "💼 Listing portfolio items..."

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
    "${API_BASE_URL}/portfolio?sort=${SORT}&order=${ORDER}")

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
    echo "✅ Portfolio items retrieved successfully!"
    COUNT=$(echo "${BODY}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('count', 0))" 2>/dev/null || echo "0")
    echo "📊 Total count: ${COUNT}"
else
    echo ""
    echo "❌ Retrieval failed"
    exit 1
fi

