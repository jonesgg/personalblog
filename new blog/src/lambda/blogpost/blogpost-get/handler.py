import json
from typing import Dict, Any

from utils.dynamodb_helper import (
    BLOGPOST_TABLE,
    get_item
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for getting a single blogpost by slug.
    
    Endpoint: GET /blogpost/{slug}
    """
    # API Gateway HTTP API v2 format
    path_params = event.get('pathParameters') or {}
    
    try:
        if 'slug' not in path_params:
            return error_response(400, "Missing slug parameter")
        
        slug = path_params['slug']
        
        # Get blogpost by slug
        item = get_item(BLOGPOST_TABLE, {'slug': slug})
        
        if item:
            return success_response(200, item)
        else:
            return error_response(404, f"Blogpost with slug '{slug}' not found")
    
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(500, f"Internal server error: {str(e)}")


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
