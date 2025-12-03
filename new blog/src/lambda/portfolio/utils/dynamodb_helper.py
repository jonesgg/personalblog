import boto3
from typing import Dict, Any, Optional
from decimal import Decimal
import json

dynamodb = boto3.resource('dynamodb')

# Table names
BLOGPOST_TABLE = 'blogpost'
PORTFOLIO_TABLE = 'portfolio'
EXPERIENCE_TABLE = 'experience'


def get_table(table_name: str):
    """Get a DynamoDB table resource."""
    return dynamodb.Table(table_name)


def decimal_default(obj):
    """JSON serializer for Decimal objects."""
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError


def serialize_item(item: Dict[str, Any]) -> Dict[str, Any]:
    """Convert DynamoDB item to JSON-serializable format."""
    return json.loads(json.dumps(item, default=decimal_default))


def deserialize_item(item: Dict[str, Any]) -> Dict[str, Any]:
    """Convert JSON item to DynamoDB format (handles Decimal conversion)."""
    return json.loads(json.dumps(item), parse_float=Decimal)


def create_item(table_name: str, item: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create a new item in DynamoDB.
    
    Args:
        table_name: Name of the DynamoDB table
        item: Dictionary containing the item data
    
    Returns:
        Created item
    """
    table = get_table(table_name)
    item = deserialize_item(item)
    table.put_item(Item=item)
    return serialize_item(item)


def get_item(table_name: str, key: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """
    Get an item from DynamoDB by key.
    
    Args:
        table_name: Name of the DynamoDB table
        key: Dictionary containing the key attributes
    
    Returns:
        Item if found, None otherwise
    """
    table = get_table(table_name)
    response = table.get_item(Key=key)
    
    if 'Item' in response:
        return serialize_item(response['Item'])
    return None


def update_item(
    table_name: str,
    key: Dict[str, Any],
    update_expression: str,
    expression_attribute_values: Dict[str, Any],
    expression_attribute_names: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """
    Update an item in DynamoDB.
    
    Args:
        table_name: Name of the DynamoDB table
        key: Dictionary containing the key attributes
        update_expression: DynamoDB update expression
        expression_attribute_values: Values for the update expression
        expression_attribute_names: Optional attribute name mappings
    
    Returns:
        Updated item
    """
    table = get_table(table_name)
    expression_attribute_values = deserialize_item(expression_attribute_values)
    
    update_params = {
        'Key': key,
        'UpdateExpression': update_expression,
        'ExpressionAttributeValues': expression_attribute_values,
        'ReturnValues': 'ALL_NEW'
    }
    
    if expression_attribute_names:
        update_params['ExpressionAttributeNames'] = expression_attribute_names
    
    response = table.update_item(**update_params)
    return serialize_item(response['Attributes'])


def delete_item(table_name: str, key: Dict[str, Any]) -> bool:
    """
    Delete an item from DynamoDB.
    
    Args:
        table_name: Name of the DynamoDB table
        key: Dictionary containing the key attributes
    
    Returns:
        True if successful, False otherwise
    """
    try:
        table = get_table(table_name)
        table.delete_item(Key=key)
        return True
    except Exception as e:
        print(f"Error deleting item: {str(e)}")
        return False


def scan_table(table_name: str, filter_expression: Optional[str] = None) -> list:
    """
    Scan a DynamoDB table (use sparingly, prefer query for large tables).
    
    Args:
        table_name: Name of the DynamoDB table
        filter_expression: Optional filter expression
    
    Returns:
        List of items
    """
    table = get_table(table_name)
    
    scan_params = {}
    if filter_expression:
        scan_params['FilterExpression'] = filter_expression
    
    response = table.scan(**scan_params)
    items = [serialize_item(item) for item in response.get('Items', [])]
    
    # Handle pagination
    while 'LastEvaluatedKey' in response:
        scan_params['ExclusiveStartKey'] = response['LastEvaluatedKey']
        response = table.scan(**scan_params)
        items.extend([serialize_item(item) for item in response.get('Items', [])])
    
    return items


def query_table(
    table_name: str,
    key_condition_expression: str,
    expression_attribute_values: Dict[str, Any],
    index_name: Optional[str] = None
) -> list:
    """
    Query a DynamoDB table.
    
    Args:
        table_name: Name of the DynamoDB table
        key_condition_expression: DynamoDB key condition expression
        expression_attribute_values: Values for the condition expression
        index_name: Optional GSI name
    
    Returns:
        List of items
    """
    table = get_table(table_name)
    expression_attribute_values = deserialize_item(expression_attribute_values)
    
    query_params = {
        'KeyConditionExpression': key_condition_expression,
        'ExpressionAttributeValues': expression_attribute_values
    }
    
    if index_name:
        query_params['IndexName'] = index_name
    
    response = table.query(**query_params)
    items = [serialize_item(item) for item in response.get('Items', [])]
    
    # Handle pagination
    while 'LastEvaluatedKey' in response:
        query_params['ExclusiveStartKey'] = response['LastEvaluatedKey']
        response = table.query(**query_params)
        items.extend([serialize_item(item) for item in response.get('Items', [])])
    
    return items

