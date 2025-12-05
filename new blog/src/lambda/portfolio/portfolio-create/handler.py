import json
import os
import hmac
from typing import Dict, Any, Tuple, Optional
from datetime import datetime

from utils.dynamodb_helper import (
    PORTFOLIO_TABLE,
    create_item,
    get_item
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for creating portfolio items.
    
    Endpoint: POST /portfolio
    """
    # Check admin token authentication
    headers = event.get('headers', {})
    admin_token = headers.get('x-admin-token', '')
    secret_token = os.environ.get('SECRET_TOKEN', '')
    
    if not secret_token or not admin_token:
        return error_response(400, "")
    
    # Verify token using constant-time comparison to prevent timing attacks
    try:
        if not hmac.compare_digest(admin_token.encode('utf-8'), secret_token.encode('utf-8')):
            return error_response(400, "")
    except Exception:
        return error_response(400, "")
    
    # API Gateway HTTP API v2 format
    body = event.get('body', '{}')
    
    # Handle base64 encoded body if needed
    if event.get('isBase64Encoded', False) and body:
        import base64
        body = base64.b64decode(body).decode('utf-8')
    
    try:
        # Parse body if it's a string
        if isinstance(body, str):
            body = json.loads(body) if body else {}
        
        # Create portfolio item
        result = create_portfolio(body)
        if 'error' in result:
            return error_response(result['status_code'], result['error'])
        return success_response(result['status_code'], result['data'])
    
    except json.JSONDecodeError:
        return error_response(400, "Invalid JSON in request body")
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(500, f"Internal server error: {str(e)}")


def validate_portfolio(data: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
    """
    Validate portfolio data structure.
    
    Returns:
        (is_valid, error_message)
    """
    # Required fields
    required_fields = ['id', 'slug', 'title', 'summary', 'content']
    for field in required_fields:
        if field not in data:
            return False, f"Missing required field: {field}"
    
    # Validate id is a string
    if not isinstance(data['id'], str) or not data['id'].strip():
        return False, "id must be a non-empty string"
    
    # Validate slug is a string
    if not isinstance(data['slug'], str) or not data['slug'].strip():
        return False, "slug must be a non-empty string"
    
    # Validate title is a string
    if not isinstance(data['title'], str) or not data['title'].strip():
        return False, "title must be a non-empty string"
    
    # Validate summary is a string
    if not isinstance(data['summary'], str) or not data['summary'].strip():
        return False, "summary must be a non-empty string"
    
    # Validate content is a list
    if not isinstance(data['content'], list):
        return False, "content must be a list"
    
    # Allowed field names in content items
    allowed_fields = {'paragraph', 'image_url', 'title'}
    
    # Each item in content list must be an object with exactly one field
    # That field must be one of: paragraph, image_url, or title
    # The field's value must be a string
    # Items can appear in any order, any amount, or not at all
    for idx, content_item in enumerate(data['content']):
        if not isinstance(content_item, dict):
            return False, f"content item at index {idx} must be an object"
        
        # Check that object has exactly one key-value pair
        if len(content_item) != 1:
            return False, f"content item at index {idx} must have exactly one field"
        
        # Get the single key and value
        key, value = next(iter(content_item.items()))
        
        # Validate the field name is allowed
        if key not in allowed_fields:
            return False, f"content item at index {idx}: field name '{key}' is not allowed. Must be one of: paragraph, image_url, or title"
        
        # Validate the value is a string
        if not isinstance(value, str):
            return False, f"content item at index {idx}: {key} must be a string"
    
    return True, None


def create_portfolio(body: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create a new portfolio item.
    
    Expected body structure:
    {
        "id": "unique-id",
        "slug": "my-portfolio-item",
        "title": "My Portfolio Item",
        "summary": "Brief summary of the portfolio item",
        "content": [
            {"title": "my title"},
            {"image_url": "https://..."},
            {"paragraph": "single paragraph"},
            {"paragraph": "single paragraph2"}
        ]
    }
    """
    # Validate the portfolio data
    is_valid, error_message = validate_portfolio(body)
    if not is_valid:
        return {'error': f"Validation error: {error_message}", 'status_code': 400}
    
    # Check if portfolio item with this slug already exists
    existing = get_item(PORTFOLIO_TABLE, {'slug': body['slug']})
    if existing:
        return {'error': f"Portfolio item with slug '{body['slug']}' already exists", 'status_code': 409}
    
    # Add created_at timestamp
    body['created_at'] = datetime.utcnow().isoformat()
    
    # Store in DynamoDB (using slug as the key)
    try:
        item = create_item(PORTFOLIO_TABLE, body)
        return {
            'data': {
                'message': 'Portfolio item created successfully',
                'slug': item['slug']
            },
            'status_code': 201
        }
    except Exception as e:
        print(f"Error creating portfolio item: {str(e)}")
        return {'error': f"Failed to create portfolio item: {str(e)}", 'status_code': 500}


def success_response(status_code: int, data: Any) -> Dict[str, Any]:
    """Create a successful API Gateway response."""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(data, default=str)
    }


def error_response(status_code: int, message: str) -> Dict[str, Any]:
    """Create an error API Gateway response."""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'error': message})
    }

