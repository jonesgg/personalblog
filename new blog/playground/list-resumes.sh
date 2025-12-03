#!/bin/bash

# Script to list all resume items
# Usage: ./list-resumes.sh [sort] [order]
# Example: ./list-resumes.sh start_month desc

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

SORT="${1:-start_month}"
ORDER="${2:-desc}"

echo "📄 Listing resume items..."

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
    "${API_BASE_URL}/resume?sort=${SORT}&order=${ORDER}")

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
    echo "✅ Resume items retrieved successfully!"
    COUNT=$(echo "${BODY}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('count', 0))" 2>/dev/null || echo "0")
    echo "📊 Total count: ${COUNT}"
else
    echo ""
    echo "❌ Retrieval failed"
    exit 1
fi

