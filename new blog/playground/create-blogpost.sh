#!/bin/bash

# Script to create a blogpost
# Usage: ./create-blogpost.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "📝 Creating blogpost..."

# Check if admin token is set
if [ -z "${ADMIN_TOKEN}" ]; then
    echo "❌ Error: ADMIN_TOKEN is not set"
    echo "Please set it in config.sh or export it as an environment variable:"
    echo "  export ADMIN_TOKEN=\"your-plain-token-here\""
    exit 1
fi

# Sample blogpost data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "blog-$(date +%s)",
  "slug": "ballers",
  "title": "Ballers",
  "title_image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/2e0c8123-5b89-42b3-af2e-f16163395bec.jpg",
  "summary": "The greatest ballers of all time",
  "content": [
    {"title": "They shaped the game, they shaped the world"},
    {"paragraph": "We can't ignore the greatest rivalry in basketball history. No it's not Lebron"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/56137c9f-6bb3-4332-9941-049b8f294e3a.jpg"},
    {"paragraph": "But maybe these had the greatest rivalry, but who was the greatest player of all time? It still isn't Lebron, who cares about him. Jordan is clealy better..."},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/6445f57b-0a1f-4b58-b4c4-9ecb1f5b3f86.png"},
    {"paragraph": "Jordan became the face of basketball. As if winning three championships in a row wasn't enough, he retired and then came back to do it all again. No one had ever done that before and it will likely never happen again."},
    {"title": "But wait, wait about the others?"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/4363349f-fce1-4ba9-bab4-4353f02338a8.jpg"},
    {"paragraph": "Yeah, this one is a baller too. No doubt"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/8015c0ec-46f1-45bb-bf88-324aebfe0770.png"},
    {"paragraph": "So is this one"}
  ],
  "date": "$(date -u +%Y-%m-%d)",
  "author": "Grant Rencher",
  "tags": ["basketball", "blog", "ballers"]
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/blogpost" \
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
    echo "✅ Blogpost created successfully!"
else
    echo ""
    echo "❌ Creation failed"
    exit 1
fi

