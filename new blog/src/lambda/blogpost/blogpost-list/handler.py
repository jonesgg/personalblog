import json
from typing import Dict, Any

from utils.dynamodb_helper import (
    BLOGPOST_TABLE,
    scan_table
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for listing all blogposts.
    
    Endpoint: GET /blogpost
    """
    # API Gateway HTTP API v2 format
    query_params = event.get('queryStringParameters') or {}
    
    try:
        # List all blogposts
        items = scan_table(BLOGPOST_TABLE)
        
        # Get optional tag filter
        filter_tag = query_params.get('tag')
        if filter_tag:
            filter_tag_lower = filter_tag.lower()
        
        # Extract simplified information and apply tag filter if provided
        simplified_blogposts = []
        for item in items:
            # Apply tag filter if provided
            if filter_tag:
                item_tags = item.get('tags', [])
                # Check if any tag matches (case-insensitive)
                tag_matches = any(
                    tag.lower() == filter_tag_lower 
                    for tag in item_tags 
                    if isinstance(tag, str)
                )
                if not tag_matches:
                    continue  # Skip this blogpost if tag doesn't match
            
            simplified = {
                'title_image_url': item.get('title_image_url', ''),
                'slug': item.get('slug', ''),
                'title': item.get('title', ''),
                'summary': item.get('summary', ''),
                'author': item.get('author', ''),
                'date': item.get('date', '')
            }
            simplified_blogposts.append(simplified)
        
        # Apply sorting
        sort_by = query_params.get('sort', 'date')
        order = query_params.get('order', 'desc')
        
        if sort_by == 'date':
            # Sort by date (most recent first by default)
            simplified_blogposts.sort(
                key=lambda x: x.get('date', ''),
                reverse=(order == 'desc')
            )
        elif sort_by == 'title':
            # Sort by title alphabetically
            simplified_blogposts.sort(
                key=lambda x: x.get('title', '').lower(),
                reverse=(order == 'desc')
            )
        
        return success_response(200, {
            'blogposts': simplified_blogposts,
            'count': len(simplified_blogposts)
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
