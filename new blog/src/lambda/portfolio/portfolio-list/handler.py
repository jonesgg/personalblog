import json
from typing import Dict, Any

from utils.dynamodb_helper import (
    PORTFOLIO_TABLE,
    scan_table
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for listing all portfolio items.
    
    Endpoint: GET /portfolio
    """
    # API Gateway HTTP API v2 format
    query_params = event.get('queryStringParameters') or {}
    
    try:
        # List all portfolio items
        items = scan_table(PORTFOLIO_TABLE)
        
        # Extract simplified information
        simplified_portfolios = []
        for item in items:
            simplified = {
                'id': item.get('id', ''),
                'slug': item.get('slug', ''),
                'title': item.get('title', '')
            }
            simplified_portfolios.append(simplified)
        
        # Apply sorting
        sort_by = query_params.get('sort', 'title')
        order = query_params.get('order', 'asc')
        
        if sort_by == 'title':
            # Sort by title alphabetically
            simplified_portfolios.sort(
                key=lambda x: x.get('title', '').lower(),
                reverse=(order == 'desc')
            )
        elif sort_by == 'created_at':
            # Sort by created_at (most recent first by default)
            simplified_portfolios.sort(
                key=lambda x: x.get('created_at', ''),
                reverse=(order == 'desc')
            )
        
        return success_response(200, {
            'portfolio': simplified_portfolios,
            'count': len(simplified_portfolios)
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

