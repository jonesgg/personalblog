# API Documentation

## Base URL

```
https://{api-id}.execute-api.{region}.amazonaws.com/{stage}
```

**Example:**
```
https://0sjwzpf8e0.execute-api.us-east-1.amazonaws.com/dev
```

## Authentication

Currently, all endpoints are publicly accessible. No authentication is required.

## Response Format

All responses are in JSON format with the following structure:

**Success Response:**
```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": { ... }
}
```

**Error Response:**
```json
{
  "statusCode": 400,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": {
    "error": "Error message here"
  }
}
```

## HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `404` - Not Found
- `409` - Conflict (duplicate resource)
- `500` - Internal Server Error

---

## Blogpost Endpoints

### Create Blogpost

Create a new blogpost.

**Endpoint:** `POST /blogpost`

**Request Body:**
```json
{
  "id": "unique-id",
  "slug": "my-blog-post",
  "title": "My Blog Post",
  "title_image_url": "https://example.com/image.jpg",
  "summary": "A brief summary of the blog post",
  "content": [
    {"title": "Introduction"},
    {"paragraph": "This is the first paragraph."},
    {"image_url": "https://example.com/content-image.jpg"},
    {"paragraph": "This is another paragraph."}
  ],
  "date": "2024-01-01",
  "author": "John Doe",
  "tags": ["tech", "python", "blog"]
}
```

**Content Structure:**
- `content` is a list of objects
- Each object must have exactly one field
- Allowed fields: `title`, `paragraph`, `image_url`
- All fields are optional strings
- Items can appear in any order, any amount, or the list can be empty

**Required Fields:**
- `id` (string) - Unique identifier
- `slug` (string) - URL-friendly identifier (must be unique)
- `title` (string) - Blog post title
- `content` (array) - Content items
- `date` (string) - Publication date (ISO format preferred)
- `author` (string) - Author name
- `tags` (array of strings) - Tags for categorization

**Optional Fields:**
- `title_image_url` (string) - Header image URL
- `summary` (string) - Brief summary

**Response:**
```json
{
  "message": "Blogpost created successfully",
  "slug": "my-blog-post"
}
```

**Error Responses:**
- `400` - Validation error (missing required fields, invalid types)
- `409` - Blogpost with this slug already exists
- `500` - Internal server error

---

### Get Blogpost by Slug

Retrieve a single blogpost by its slug.

**Endpoint:** `GET /blogpost/{slug}`

**Path Parameters:**
- `slug` (string, required) - The slug of the blogpost

**Response:**
```json
{
  "id": "unique-id",
  "slug": "my-blog-post",
  "title": "My Blog Post",
  "title_image_url": "https://example.com/image.jpg",
  "summary": "A brief summary",
  "content": [
    {"title": "Introduction"},
    {"paragraph": "This is the first paragraph."}
  ],
  "date": "2024-01-01",
  "author": "John Doe",
  "tags": ["tech", "python"],
  "created_at": "2024-01-01T12:00:00.000000"
}
```

**Error Responses:**
- `400` - Missing slug parameter
- `404` - Blogpost not found
- `500` - Internal server error

---

### List Blogposts

List all blogposts with optional filtering and sorting.

**Endpoint:** `GET /blogpost`

**Query Parameters:**
- `tag` (string, optional) - Filter by tag (case-insensitive)
- `sort` (string, optional) - Sort field: `date` (default) or `title`
- `order` (string, optional) - Sort order: `desc` (default) or `asc`

**Examples:**
```
GET /blogpost
GET /blogpost?tag=tech
GET /blogpost?tag=python&sort=date&order=desc
GET /blogpost?sort=title&order=asc
```

**Response:**
```json
{
  "blogposts": [
    {
      "title_image_url": "https://example.com/image.jpg",
      "slug": "my-blog-post",
      "title": "My Blog Post",
      "summary": "A brief summary",
      "author": "John Doe",
      "date": "2024-01-01"
    }
  ],
  "count": 1
}
```

**Error Responses:**
- `500` - Internal server error

---

## Portfolio Endpoints

### Create Portfolio Item

Create a new portfolio item.

**Endpoint:** `POST /portfolio`

**Request Body:**
```json
{
  "id": "unique-id",
  "slug": "my-portfolio-project",
  "title": "My Portfolio Project",
  "summary": "A brief summary of the portfolio project",
  "content": [
    {"title": "Project Overview"},
    {"paragraph": "This is a description of my project."},
    {"image_url": "https://example.com/project-image.jpg"},
    {"paragraph": "More details about the project."}
  ]
}
```

**Content Structure:**
- Same structure as blogpost content (list of single-field objects)
- Allowed fields: `title`, `paragraph`, `image_url`

**Required Fields:**
- `id` (string) - Unique identifier
- `slug` (string) - URL-friendly identifier (must be unique)
- `title` (string) - Portfolio item title
- `summary` (string) - Brief summary of the portfolio item
- `content` (array) - Content items

**Response:**
```json
{
  "message": "Portfolio item created successfully",
  "slug": "my-portfolio-project"
}
```

**Error Responses:**
- `400` - Validation error
- `409` - Portfolio item with this slug already exists
- `500` - Internal server error

---

### Get Portfolio Item by Slug

Retrieve a single portfolio item by its slug.

**Endpoint:** `GET /portfolio/{slug}`

**Path Parameters:**
- `slug` (string, required) - The slug of the portfolio item

**Response:**
```json
{
  "id": "unique-id",
  "slug": "my-portfolio-project",
  "title": "My Portfolio Project",
  "summary": "A brief summary of the portfolio project",
  "content": [
    {"title": "Project Overview"},
    {"paragraph": "This is a description."}
  ],
  "created_at": "2024-01-01T12:00:00.000000"
}
```

**Error Responses:**
- `400` - Missing slug parameter
- `404` - Portfolio item not found
- `500` - Internal server error

---

### List Portfolio Items

List all portfolio items with optional sorting.

**Endpoint:** `GET /portfolio`

**Query Parameters:**
- `sort` (string, optional) - Sort field: `title` (default) or `created_at`
- `order` (string, optional) - Sort order: `asc` (default) or `desc`

**Examples:**
```
GET /portfolio
GET /portfolio?sort=title&order=asc
GET /portfolio?sort=created_at&order=desc
```

**Response:**
```json
{
  "portfolio": [
    {
      "id": "unique-id",
      "slug": "my-portfolio-project",
      "title": "My Portfolio Project",
      "summary": "A brief summary of the portfolio project"
    }
  ],
  "count": 1
}
```

**Error Responses:**
- `500` - Internal server error

---

## Resume Endpoints

### Create Resume Item

Create a new resume/experience item.

**Endpoint:** `POST /resume`

**Request Body:**
```json
{
  "id": "unique-id",
  "title": "Software Engineer",
  "company_name": "Adobe",
  "image_url": "https://example.com/company-logo.jpg",
  "start_month": "2024-01",
  "end_month": "2024-12",
  "description": "Software Engineer at Example Company. Worked on various projects."
}
```

**Required Fields:**
- `id` (string) - Unique identifier
- `title` (string) - Position/job title
- `company_name` (string) - Company name
- `image_url` (string) - Company/logo image URL
- `start_month` (string) - Start month (format: "YYYY-MM")
- `end_month` (string) - End month (format: "YYYY-MM", can be empty string for current positions)
- `description` (string) - Job/experience description

**Response:**
```json
{
  "message": "Resume item created successfully",
  "id": "unique-id"
}
```

**Error Responses:**
- `400` - Validation error
- `409` - Resume item with this id already exists
- `500` - Internal server error

---

### List Resume Items

List all resume items with optional sorting.

**Endpoint:** `GET /resume`

**Query Parameters:**
- `sort` (string, optional) - Sort field: `start_month` (default), `end_month`, or `created_at`
- `order` (string, optional) - Sort order: `desc` (default) or `asc`

**Examples:**
```
GET /resume
GET /resume?sort=start_month&order=desc
GET /resume?sort=created_at&order=asc
```

**Response:**
```json
{
  "resume": [
    {
      "id": "unique-id",
      "title": "Software Engineer",
      "company_name": "Example Company",
      "image_url": "https://example.com/company-logo.jpg",
      "start_month": "2024-01",
      "end_month": "2024-12",
      "description": "Software Engineer at Example Company.",
      "created_at": "2024-01-01T12:00:00.000000"
    }
  ],
  "count": 1
}
```

**Error Responses:**
- `500` - Internal server error

---

## Image Upload Endpoint

### Upload Image

Upload an image to S3 and get the public URL.

**Endpoint:** `POST /image/upload`

**Request Body:**
```json
{
  "imageBytes": "base64-encoded-image-data",
  "imageFileExtension": ".jpg"
}
```

**Required Fields:**
- `imageBytes` (string) - Base64-encoded image data
- `imageFileExtension` (string, optional) - File extension (defaults to `.jpg` if not provided)

**Supported Extensions:**
- `.jpg` / `.jpeg` → `image/jpeg`
- `.png` → `image/png`
- `.gif` → `image/gif`
- `.webp` → `image/webp`

**Response:**
```json
{
  "imageUrl": "https://bucket-name.s3.region.amazonaws.com/uuid.jpg",
  "imageId": "uuid-here"
}
```

**Error Responses:**
- `400` - Missing imageBytes or invalid base64 encoding
- `500` - Failed to upload image or S3 error

**Example (JavaScript):**
```javascript
const fileInput = document.querySelector('input[type="file"]');
const file = fileInput.files[0];
const reader = new FileReader();

reader.onload = async function(e) {
  const base64 = e.target.result.split(',')[1]; // Remove data:image/jpeg;base64, prefix
  const extension = '.' + file.name.split('.').pop();
  
  const response = await fetch('https://api.example.com/dev/image/upload', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      imageBytes: base64,
      imageFileExtension: extension
    })
  });
  
  const data = await response.json();
  console.log('Image URL:', data.imageUrl);
};

reader.readAsDataURL(file);
```

---

## Content Structure Details

### Content Array Format

Both blogpost and portfolio items use a `content` array with the following structure:

```json
"content": [
  {"title": "Section Title"},
  {"paragraph": "First paragraph of text."},
  {"image_url": "https://example.com/image.jpg"},
  {"paragraph": "Second paragraph of text."},
  {"title": "Another Section Title"}
]
```

**Rules:**
- Each item in the array is an object with exactly one field
- Allowed field names: `title`, `paragraph`, `image_url`
- All field values must be strings
- Items can appear in any order
- Any number of items (including zero)
- Empty array `[]` is allowed

**Examples:**

Single paragraph:
```json
"content": [
  {"paragraph": "Just one paragraph."}
]
```

Multiple paragraphs:
```json
"content": [
  {"paragraph": "First paragraph."},
  {"paragraph": "Second paragraph."},
  {"paragraph": "Third paragraph."}
]
```

Mixed content:
```json
"content": [
  {"title": "Introduction"},
  {"paragraph": "This is the intro paragraph."},
  {"image_url": "https://example.com/image.jpg"},
  {"title": "Conclusion"},
  {"paragraph": "This is the conclusion."}
]
```

---

## Error Handling

All endpoints return consistent error responses:

```json
{
  "error": "Descriptive error message"
}
```

**Common Error Messages:**

- `"Missing required field: {field}"` - Required field is missing
- `"Validation error: {message}"` - Data validation failed
- `"Blogpost with slug '{slug}' already exists"` - Duplicate slug
- `"Portfolio item with slug '{slug}' already exists"` - Duplicate slug
- `"Resume item with id '{id}' already exists"` - Duplicate id
- `"Invalid JSON in request body"` - Malformed JSON
- `"Internal server error: {details}"` - Server-side error

---

## Rate Limiting

Current rate limits (configured in API Gateway):
- Throttling rate: 100 requests per second
- Burst limit: 50 requests

---

## CORS

All endpoints support CORS with the following configuration:
- Allowed origins: `*` (all origins)
- Allowed methods: `*` (all methods)
- Allowed headers: `*` (all headers)

---

## Examples

### Complete Blogpost Creation Example

```bash
curl -X POST https://api.example.com/dev/blogpost \
  -H "Content-Type: application/json" \
  -d '{
    "id": "blog-001",
    "slug": "my-first-blog-post",
    "title": "My First Blog Post",
    "title_image_url": "https://example.com/header.jpg",
    "summary": "This is my first blog post about web development.",
    "content": [
      {"title": "Introduction"},
      {"paragraph": "Welcome to my blog! This is my first post."},
      {"image_url": "https://example.com/content-image.jpg"},
      {"paragraph": "I hope you enjoy reading this."}
    ],
    "date": "2024-01-15",
    "author": "John Doe",
    "tags": ["web-dev", "blog", "first-post"]
  }'
```

### Complete Portfolio Creation Example

```bash
curl -X POST https://api.example.com/dev/portfolio \
  -H "Content-Type: application/json" \
  -d '{
    "id": "portfolio-001",
    "slug": "e-commerce-platform",
    "title": "E-Commerce Platform",
    "content": [
      {"title": "Project Overview"},
      {"paragraph": "Built a full-stack e-commerce platform using React and Node.js."},
      {"image_url": "https://example.com/project-screenshot.jpg"},
      {"paragraph": "The platform supports user authentication, product catalog, and payment processing."}
    ]
  }'
```

### Image Upload Example

```bash
# First, convert image to base64
IMAGE_BASE64=$(base64 -i image.jpg | tr -d '\n')

curl -X POST https://api.example.com/dev/image/upload \
  -H "Content-Type: application/json" \
  -d "{
    \"imageBytes\": \"${IMAGE_BASE64}\",
    \"imageFileExtension\": \".jpg\"
  }"
```

---

## Testing

Test scripts are available in the `playground/` directory:

- `create-blogpost.sh` - Create a blogpost
- `get-blogpost.sh <slug>` - Get a blogpost
- `list-blogposts.sh [tag] [sort] [order]` - List blogposts
- `create-portfolio.sh` - Create a portfolio item
- `get-portfolio.sh <slug>` - Get a portfolio item
- `list-portfolios.sh [sort] [order]` - List portfolio items
- `create-resume.sh` - Create a resume item
- `list-resumes.sh [sort] [order]` - List resume items
- `upload-image.sh <image-file> [extension]` - Upload an image

See `playground/README.md` for more details.

---

## Changelog

### Current Version
- All endpoints support CORS
- Content structure uses single-field objects in arrays
- Portfolio and blogpost use slug-based retrieval
- Image upload supports multiple formats
- Tag filtering for blogposts
- Sorting options for all list endpoints

