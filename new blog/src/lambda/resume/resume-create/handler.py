import json
import os
import hmac
from typing import Dict, Any, Tuple, Optional
from datetime import datetime

from utils.dynamodb_helper import (
    EXPERIENCE_TABLE,
    create_item,
    get_item
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for creating resume items.
    
    Endpoint: POST /resume
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
        
        # Create resume item
        result = create_resume(body)
        if 'error' in result:
            return error_response(result['status_code'], result['error'])
        return success_response(result['status_code'], result['data'])
    
    except json.JSONDecodeError:
        return error_response(400, "Invalid JSON in request body")
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(500, f"Internal server error: {str(e)}")


def validate_resume(data: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
    """
    Validate resume data structure.
    
    Returns:
        (is_valid, error_message)
    """
    # Required fields
    required_fields = ['id', 'title', 'company_name', 'image_url', 'start_month', 'end_month', 'description']
    for field in required_fields:
        if field not in data:
            return False, f"Missing required field: {field}"
    
    # Validate id is a string
    if not isinstance(data['id'], str) or not data['id'].strip():
        return False, "id must be a non-empty string"
    
    # Validate title is a string
    if not isinstance(data['title'], str) or not data['title'].strip():
        return False, "title must be a non-empty string"
    
    # Validate company_name is a string
    if not isinstance(data['company_name'], str) or not data['company_name'].strip():
        return False, "company_name must be a non-empty string"
    
    # Validate image_url is a string
    if not isinstance(data['image_url'], str) or not data['image_url'].strip():
        return False, "image_url must be a non-empty string"
    
    # Validate start_month is a string
    if not isinstance(data['start_month'], str) or not data['start_month'].strip():
        return False, "start_month must be a non-empty string"
    
    # Validate end_month is a string (can be empty for current positions)
    if not isinstance(data['end_month'], str):
        return False, "end_month must be a string"
    
    # Validate description is a string
    if not isinstance(data['description'], str) or not data['description'].strip():
        return False, "description must be a non-empty string"
    
    return True, None


def create_resume(body: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create a new resume item.
    
    Expected body structure:
    {
        "id": "unique-id",
        "title": "Position Title",
        "company_name": "Company Name",
        "image_url": "https://...",
        "start_month": "2024-01",
        "end_month": "2024-12",
        "description": "Job description here"
    }
    """
    # Validate the resume data
    is_valid, error_message = validate_resume(body)
    if not is_valid:
        return {'error': f"Validation error: {error_message}", 'status_code': 400}
    
    # Check if resume item with this id already exists
    existing = get_item(EXPERIENCE_TABLE, {'id': body['id']})
    if existing:
        return {'error': f"Resume item with id '{body['id']}' already exists", 'status_code': 409}
    
    # Add created_at timestamp
    body['created_at'] = datetime.utcnow().isoformat()
    
    # Store in DynamoDB (using id as the key)
    try:
        item = create_item(EXPERIENCE_TABLE, body)
        return {
            'data': {
                'message': 'Resume item created successfully',
                'id': item['id']
            },
            'status_code': 201
        }
    except Exception as e:
        print(f"Error creating resume item: {str(e)}")
        return {'error': f"Failed to create resume item: {str(e)}", 'status_code': 500}


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

