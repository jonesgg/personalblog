#!/bin/bash

# Script to upload an image to S3 via the API
# Supports JPG, JPEG, and PNG formats
# Usage: ./upload-image.sh <image-file> [extension]
# Example: ./upload-image.sh images/test.jpg .jpg
# Example: ./upload-image.sh images/test.png .png

set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

# Check if admin token is set
if [ -z "${ADMIN_TOKEN}" ]; then
    echo "❌ Error: ADMIN_TOKEN is not set"
    echo "Please set it in config.sh or export it as an environment variable:"
    echo "  export ADMIN_TOKEN=\"your-plain-token-here\""
    exit 1
fi

# Require command line argument
if [ $# -lt 1 ]; then
    echo "Error: Image file argument is required"
    echo "Usage: $0 <image-file> [extension]"
    echo "Example: $0 images/test.jpg .jpg"
    echo "Example: $0 images/test.png .png"
    exit 1
fi

IMAGE_FILE="$1"
EXTENSION="${2:-}"

# Check if file exists
if [ ! -f "${IMAGE_FILE}" ]; then
    echo "Error: Image file not found: ${IMAGE_FILE}"
    exit 1
fi

# Get extension from filename if not provided
if [ -z "${EXTENSION}" ]; then
    EXTENSION=".${IMAGE_FILE##*.}"
fi

# Ensure extension starts with dot
if [[ ! "${EXTENSION}" =~ ^\. ]]; then
    EXTENSION=".${EXTENSION}"
fi

# Normalize extension to lowercase
EXTENSION=$(echo "${EXTENSION}" | tr '[:upper:]' '[:lower:]')

# Normalize .jpeg to .jpg for consistency
if [ "${EXTENSION}" = ".jpeg" ]; then
    EXTENSION=".jpg"
fi

# Validate extension (only allow common image formats)
VALID_EXTENSIONS=(".jpg" ".png")
if [[ ! " ${VALID_EXTENSIONS[@]} " =~ " ${EXTENSION} " ]]; then
    echo "❌ Error: Unsupported image format: ${EXTENSION}"
    echo "Supported formats: JPG, PNG"
    exit 1
fi

echo "📤 Uploading image: ${IMAGE_FILE}"
echo "📎 Extension: ${EXTENSION}"

# Convert image to base64 (macOS compatible)
echo "🔄 Encoding image to base64..."
if ! IMAGE_BASE64=$(base64 -i "${IMAGE_FILE}" 2>/dev/null | tr -d '\n'); then
    echo "❌ Error: Failed to encode image to base64"
    exit 1
fi

# Create temporary file for JSON payload to avoid "Argument list too long" error
TEMP_JSON=$(mktemp)
trap "rm -f ${TEMP_JSON}" EXIT

# Create JSON payload in temp file
echo "📝 Creating JSON payload..."
cat > "${TEMP_JSON}" <<EOF
{
  "imageBytes": "${IMAGE_BASE64}",
  "imageFileExtension": "${EXTENSION}"
}
EOF

# Make API call using file input
echo "🌐 Sending request to API..."
echo "   URL: ${API_BASE_URL}/image/upload"
if ! RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE_URL}/image/upload" \
    -H "Content-Type: application/json" \
    -H "x-admin-token: ${ADMIN_TOKEN}" \
    -d "@${TEMP_JSON}" \
    --max-time 60 \
    --connect-timeout 10); then
    echo "❌ Error: Failed to connect to API"
    exit 1
fi

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
    echo "✅ Image uploaded successfully!"
    # Extract image URL if possible
    IMAGE_URL=$(echo "${BODY}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('imageUrl', ''))" 2>/dev/null || echo "")
    if [ -n "${IMAGE_URL}" ]; then
        echo "🖼️  Image URL: ${IMAGE_URL}"
    fi
else
    echo ""
    echo "❌ Upload failed"
    exit 1
fi

