# API Testing Scripts

This directory contains scripts to test all API endpoints.

## Setup

1. **Get your API Gateway URL**:
   ```bash
   cd ../terraform
   terraform output -raw api_gateway_url
   ```

2. **Set the API URL** in `config.sh` or export it:
   ```bash
   export API_BASE_URL="https://your-api-id.execute-api.region.amazonaws.com"
   ```

## Scripts

### Image Upload
```bash
./upload-image.sh <image-file> [extension]
./upload-image.sh images/test.jpg .jpg
```
Converts the image to base64 and uploads it to S3.

### Blogpost Endpoints
```bash
# Create a blogpost
./create-blogpost.sh

# Get a blogpost by slug
./get-blogpost.sh <slug>

# List all blogposts
./list-blogposts.sh [tag] [sort] [order]
./list-blogposts.sh tech date desc
```

### Portfolio Endpoints
```bash
# Create a portfolio item
./create-portfolio.sh

# Get a portfolio item by slug
./get-portfolio.sh <slug>

# List all portfolio items
./list-portfolios.sh [sort] [order]
```

### Resume Endpoints
```bash
# Create a resume item
./create-resume.sh

# List all resume items
./list-resumes.sh [sort] [order]
```

## Notes

- All scripts use the `config.sh` file for API URL configuration
- The image upload script automatically converts images to base64 format
- All scripts output formatted JSON responses
- Scripts exit with error code 1 if the API call fails

