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
  "slug": "my-personal-website",
  "title": "My Personal Website",
  "title_image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/2e0c8123-5b89-42b3-af2e-f16163395bec.jpg",
  "summary": "A journey of five years: How I built my personal website.",
  "content": [
    {"title": "How it started"},
    {"paragraph": "Back in 2020 I took a job at BYU OIT and learned the basics of web development. I loved what I was doing and wanted to practice my skills more. By the end of my freshman year I had built a basic website with my resume. It was pretty basic but I was proud of it."},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/af161e36-202a-4391-a617-14c9957a1845.png"},
    {"paragraph": "The website served as a nice resume reference for employers but as the years went by it was clear that I needed something more. The biggest issue was always time. I wanted to build a blog along with a slick new site but I never had enough time. I had even tried twice but stopped midway through the project because I ran out of time."},
    {"title": "A new opportunity"},
    {"paragraph": "Fortunetely, I took this class with a professor who was willing to give his students time to work on something meaningful to them. In all honesty I'm a senior who has been grinding for a while and just wants to be done. This project gave me the opportunity to work on something that I care about and I'm very grateful for it."},
    {"title": "Site Architecture"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/74976594-6eff-447d-82ba-f7e523b9c868.png"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/58ec575b-f35c-4f67-be27-99acfbddafcb.png"},
    {"image_url": "https://blog-backend-images-020141610921.s3.us-east-1.amazonaws.com/13a350e8-9dbc-463b-a584-6e30442ec122.png"}
  ],
  "date": "$(date -u +%Y-%m-%d)",
  "author": "Grant Rencher",
  "tags": ["programming", "blog", "portfolio"]
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

