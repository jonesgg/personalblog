import json
import os
from typing import Dict, Any

from utils.dynamodb_helper import (
    PORTFOLIO_TABLE,
    create_item,
    get_item,
    update_item,
    delete_item,
    scan_table
)


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for Portfolio API endpoints.
    
    Supports API Gateway HTTP API (v2) event format.
    """
    # API Gateway HTTP API v2 format
    request_context = event.get('requestContext', {})
    http_info = request_context.get('http', {})
    http_method = http_info.get('method', '').upper()
    raw_path = event.get('rawPath', '')
    path_params = event.get('pathParameters') or {}
    query_params = event.get('queryStringParameters') or {}
    body = event.get('body', '{}')
    
    # Handle base64 encoded body if needed
    if event.get('isBase64Encoded', False) and body:
        import base64
        body = base64.b64decode(body).decode('utf-8')
    
    try:
        # Parse body if it's a string
        if isinstance(body, str):
            body = json.loads(body) if body else {}
        
        # Route based on HTTP method and path
        if http_method == 'GET':
            if 'id' in path_params:
                # Get single portfolio item
                return get_portfolio_item(path_params['id'])
            else:
                # List all portfolio items
                return list_portfolio_items(query_params)
        
        elif http_method == 'POST':
            # Create new portfolio item
            return create_portfolio_item(body)
        
        elif http_method == 'PUT':
            # Update portfolio item
            if 'id' in path_params:
                return update_portfolio_item(path_params['id'], body)
            else:
                return error_response(400, "Missing portfolio item ID in path")
        
        elif http_method == 'DELETE':
            # Delete portfolio item
            if 'id' in path_params:
                return delete_portfolio_item(path_params['id'])
            else:
                return error_response(400, "Missing portfolio item ID in path")
        
        else:
            return error_response(405, f"Method {http_method} not allowed")
    
    except json.JSONDecodeError:
        return error_response(400, "Invalid JSON in request body")
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(500, f"Internal server error: {str(e)}")


def get_portfolio_item(item_id: str) -> Dict[str, Any]:
    """Get a single portfolio item by ID."""
    item = get_item(PORTFOLIO_TABLE, {'id': item_id})
    
    if item:
        return success_response(200, item)
    else:
        return error_response(404, "Portfolio item not found")


def list_portfolio_items(query_params: Dict[str, Any]) -> Dict[str, Any]:
    """List all portfolio items (with optional filtering)."""
    items = scan_table(PORTFOLIO_TABLE)
    
    # Apply any query parameter filters here if needed
    # For example: filter by category, technology, etc.
    
    return success_response(200, {'portfolio': items, 'count': len(items)})


def create_portfolio_item(body: Dict[str, Any]) -> Dict[str, Any]:
    """Create a new portfolio item."""
    # Validate required fields
    required_fields = ['id', 'title']
    for field in required_fields:
        if field not in body:
            return error_response(400, f"Missing required field: {field}")
    
    # Add timestamp if not provided
    if 'created_at' not in body:
        from datetime import datetime
        body['created_at'] = datetime.utcnow().isoformat()
    
    item = create_item(PORTFOLIO_TABLE, body)
    return success_response(201, item)


def update_portfolio_item(item_id: str, body: Dict[str, Any]) -> Dict[str, Any]:
    """Update an existing portfolio item."""
    # Build update expression dynamically
    update_expr_parts = []
    expr_attr_values = {}
    expr_attr_names = {}
    
    for key, value in body.items():
        if key != 'id':  # Don't update the ID
            placeholder = f":{key.replace('-', '_')}"
            name_placeholder = f"#{key.replace('-', '_')}"
            update_expr_parts.append(f"{name_placeholder} = {placeholder}")
            expr_attr_values[placeholder] = value
            expr_attr_names[name_placeholder] = key
    
    if not update_expr_parts:
        return error_response(400, "No fields to update")
    
    update_expression = "SET " + ", ".join(update_expr_parts)
    
    # Add updated_at timestamp
    from datetime import datetime
    update_expression += ", #updated_at = :updated_at"
    expr_attr_values[":updated_at"] = datetime.utcnow().isoformat()
    expr_attr_names["#updated_at"] = "updated_at"
    
    try:
        item = update_item(
            PORTFOLIO_TABLE,
            {'id': item_id},
            update_expression,
            expr_attr_values,
            expr_attr_names
        )
        return success_response(200, item)
    except Exception as e:
        return error_response(404, f"Portfolio item not found or update failed: {str(e)}")


def delete_portfolio_item(item_id: str) -> Dict[str, Any]:
    """Delete a portfolio item."""
    success = delete_item(PORTFOLIO_TABLE, {'id': item_id})
    
    if success:
        return success_response(200, {'message': 'Portfolio item deleted successfully'})
    else:
        return error_response(404, "Portfolio item not found")


def success_response(status_code: int, data: Any) -> Dict[str, Any]:
    """Create a successful API Gateway response."""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(data)
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

