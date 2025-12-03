#!/bin/bash

# Script to create a blogpost
# Usage: ./create-blogpost.sh

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "📝 Creating blogpost..."

# Sample blogpost data - modify as needed
JSON_PAYLOAD=$(cat <<EOF
{
  "id": "blog-$(date +%s)",
  "slug": "my-test-blogpost-$(date +%s)",
  "title": "Test Blog Post",
  "title_image_url": "https://example.com/image.jpg",
  "summary": "This is a test blog post summary",
  "content": [
    {"title": "Introduction"},
    {"paragraph": "This is the first paragraph of the blog post."},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/51533ab9-ffdb-4a87-9af5-668acbdbda10.jpg"},
    {"paragraph": "This is another paragraph."}
  ],
  "date": "$(date -u +%Y-%m-%d)",
  "author": "Test Author",
  "tags": ["test", "blog", "example", "gospel"]
}
EOF
)

# Make API call
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/blogpost" \
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
    echo "✅ Blogpost created successfully!"
else
    echo ""
    echo "❌ Creation failed"
    exit 1
fi

