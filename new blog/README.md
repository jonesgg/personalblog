# Backend API - Lambda + API Gateway + DynamoDB

A serverless backend API built with AWS Lambda (Python), API Gateway, and DynamoDB, deployed using Terraform.

## Architecture

- **Lambda Functions**: Three Lambda functions for Blogpost, Portfolio, and Resume APIs
- **API Gateway**: HTTP API Gateway with RESTful endpoints for each resource
- **DynamoDB**: Three tables (blogpost, portfolio, experience)
- **S3**: Image storage with helper utilities
- **Terraform**: Infrastructure as Code for all AWS resources

## Project Structure

```
.
├── src/
│   ├── lambda/
│   │   ├── blogpost/
│   │   │   ├── handler.py          # Blogpost API Lambda handler
│   │   │   └── utils/              # Shared utilities (copied)
│   │   ├── portfolio/
│   │   │   ├── handler.py          # Portfolio API Lambda handler
│   │   │   └── utils/              # Shared utilities (copied)
│   │   └── resume/
│   │       ├── handler.py          # Resume API Lambda handler
│   │       └── utils/              # Shared utilities (copied)
│   └── utils/
│       ├── s3_helper.py            # S3 image upload utilities
│       └── dynamodb_helper.py     # DynamoDB CRUD utilities
├── terraform/
│   ├── main.tf                     # Main Terraform configuration
│   ├── variables.tf                # Variable definitions
│   ├── outputs.tf                  # Output values
│   ├── dynamodb.tf                 # DynamoDB table definitions
│   ├── s3.tf                       # S3 bucket configuration
│   ├── lambda.tf                   # Lambda function definitions
│   ├── api_gateway.tf              # API Gateway configuration
│   ├── iam.tf                      # IAM roles and policies
│   └── terraform.tfvars.example    # Example variables file
├── requirements.txt                # Python dependencies
└── README.md                       # This file
```

## DynamoDB Tables

### blogpost
- **Primary Key**: `id` (String)
- Stores blog post entries

### portfolio
- **Primary Key**: `id` (String)
- Stores portfolio project entries

### experience
- **Primary Key**: `id` (String)
- Stores work/education experience entries

## API Endpoints

### Blogpost API
- `GET /blogpost` - List all blogposts
- `GET /blogpost/{id}` - Get a specific blogpost
- `POST /blogpost` - Create a new blogpost
- `PUT /blogpost/{id}` - Update a blogpost
- `DELETE /blogpost/{id}` - Delete a blogpost

### Portfolio API
- `GET /portfolio` - List all portfolio items
- `GET /portfolio/{id}` - Get a specific portfolio item
- `POST /portfolio` - Create a new portfolio item
- `PUT /portfolio/{id}` - Update a portfolio item
- `DELETE /portfolio/{id}` - Delete a portfolio item

### Resume API
- `GET /resume` - List all experience entries
- `GET /resume/{id}` - Get a specific experience entry
- `POST /resume` - Create a new experience entry
- `PUT /resume/{id}` - Update an experience entry
- `DELETE /resume/{id}` - Delete an experience entry

## S3 Image Helper

The `utils/s3_helper.py` module provides functions for uploading images to S3:

```python
import os
from utils.s3_helper import upload_image_to_s3

# Upload an image
image_url = upload_image_to_s3(
    file_content=image_bytes,
    bucket_name=os.environ['S3_BUCKET'],
    file_name='my-image.jpg',
    content_type='image/jpeg',
    folder='blog-images'
)
```

## Setup and Deployment

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- Python 3.11+
- AWS account with appropriate permissions

### Local Development

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Test Lambda functions locally (you may want to use tools like `lambda-local` or AWS SAM CLI for local testing)

### Terraform Deployment

1. Navigate to the terraform directory:
```bash
cd terraform
```

2. Copy the example variables file and customize:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your desired configuration:
```hcl
aws_region      = "us-east-1"
project_name    = "blog-backend"
environment     = "dev"
s3_bucket_name  = ""  # Leave empty for auto-generated name
lambda_runtime  = "python3.11"
lambda_timeout  = 30
lambda_memory_size = 256
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the deployment plan:
```bash
terraform plan
```

5. Deploy the infrastructure:
```bash
terraform apply
```

6. After deployment, Terraform will output the API Gateway URLs and other resource information.

### Updating Lambda Functions

When you update Lambda function code:

1. Make your changes in `src/lambda/`
2. Navigate to terraform directory:
```bash
cd terraform
```

3. Apply changes:
```bash
terraform apply
```

Terraform will automatically detect code changes and update the Lambda functions.

### Destroying Resources

To tear down all resources:
```bash
cd terraform
terraform destroy
```

**Warning**: This will delete all DynamoDB tables, S3 buckets, and other resources. Make sure you have backups if needed.

## Environment Variables

The Lambda functions have access to the following environment variables (automatically set by Terraform):
- `BLOGPOST_TABLE`: DynamoDB table name for blogposts
- `PORTFOLIO_TABLE`: DynamoDB table name for portfolio items
- `EXPERIENCE_TABLE`: DynamoDB table name for experience entries
- `S3_BUCKET`: S3 bucket name for images

## Example Requests

After deployment, get your API URL from Terraform outputs:
```bash
cd terraform
terraform output api_gateway_url
```

### Create a Blogpost
```bash
curl -X POST https://your-api-id.execute-api.region.amazonaws.com/dev/blogpost \
  -H "Content-Type: application/json" \
  -d '{
    "id": "post-1",
    "title": "My First Post",
    "content": "This is the content of my blog post",
    "author": "John Doe",
    "tags": ["tech", "python"]
  }'
```

### Get All Portfolio Items
```bash
curl https://your-api-id.execute-api.region.amazonaws.com/dev/portfolio
```

### Create an Experience Entry
```bash
curl -X POST https://your-api-id.execute-api.region.amazonaws.com/dev/resume \
  -H "Content-Type: application/json" \
  -d '{
    "id": "exp-1",
    "title": "Software Engineer",
    "company": "Tech Corp",
    "start_date": "2020-01-01",
    "end_date": "2023-12-31",
    "description": "Worked on awesome projects"
  }'
```

## Terraform Outputs

After deployment, you can view all outputs:
```bash
cd terraform
terraform output
```

Key outputs include:
- `api_gateway_url`: Base API Gateway URL
- `blogpost_api_url`: Blogpost API endpoint
- `portfolio_api_url`: Portfolio API endpoint
- `resume_api_url`: Resume API endpoint
- `s3_bucket_name`: S3 bucket for images
- `dynamodb_tables`: All DynamoDB table names
- `lambda_functions`: All Lambda function names

## Next Steps

- Add authentication/authorization (API Keys, Cognito, etc.)
- Implement pagination for list endpoints
- Add filtering and sorting capabilities
- Set up CloudWatch logging and monitoring
- Add input validation schemas
- Implement rate limiting
- Add unit tests
- Set up CI/CD pipeline for automated deployments
