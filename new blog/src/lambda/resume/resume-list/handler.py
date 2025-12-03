import json
from typing import Dict, Any

from utils.dynamodb_helper import (
    EXPERIENCE_TABLE,
    scan_table
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for listing all resume items.
    
    Endpoint: GET /resume
    """
    # API Gateway HTTP API v2 format
    query_params = event.get('queryStringParameters') or {}
    
    try:
        # List all resume items
        items = scan_table(EXPERIENCE_TABLE)
        
        # Apply sorting
        sort_by = query_params.get('sort', 'start_month')
        order = query_params.get('order', 'desc')
        
        if sort_by == 'start_month':
            # Sort by start_month (most recent first by default)
            items.sort(
                key=lambda x: x.get('start_month', ''),
                reverse=(order == 'desc')
            )
        elif sort_by == 'end_month':
            # Sort by end_month
            items.sort(
                key=lambda x: x.get('end_month', ''),
                reverse=(order == 'desc')
            )
        elif sort_by == 'created_at':
            # Sort by created_at
            items.sort(
                key=lambda x: x.get('created_at', ''),
                reverse=(order == 'desc')
            )
        
        return success_response(200, {
            'resume': items,
            'count': len(items)
        })
    
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

