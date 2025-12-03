#!/bin/bash

# Script to list all blogposts
# Usage: ./list-blogposts.sh [tag] [sort] [order]
# Example: ./list-blogposts.sh tech date desc
# Example: ./list-blogposts.sh "" title asc

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

TAG="${1:-}"
SORT="${2:-date}"
ORDER="${3:-desc}"

echo "📋 Listing blogposts..."

# Build query string
QUERY_PARAMS="sort=${SORT}&order=${ORDER}"
if [ -n "${TAG}" ]; then
    QUERY_PARAMS="${QUERY_PARAMS}&tag=${TAG}"
fi

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
    "${API_BASE_URL}/blogpost?${QUERY_PARAMS}")

# Extract HTTP status code (last line)
HTTP_CODE=$(echo "${RESPONSE}" | tail -n1)
BODY=$(echo "${RESPONSE}" | sed '$d')

# Print response
echo ""
echo "Status Code: ${HTTP_CODE}"
if [ -n "${TAG}" ]; then
    echo "Filtered by tag: ${TAG}"
fi
echo "Response:"
echo "${BODY}" | python3 -m json.tool 2>/dev/null || echo "${BODY}"

if [ "${HTTP_CODE}" -eq 200 ]; then
    echo ""
    echo "✅ Blogposts retrieved successfully!"
    COUNT=$(echo "${BODY}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('count', 0))" 2>/dev/null || echo "0")
    echo "📊 Total count: ${COUNT}"
else
    echo ""
    echo "❌ Retrieval failed"
    exit 1
fi

