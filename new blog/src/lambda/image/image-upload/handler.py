import json
import base64
import os
import uuid
from typing import Dict, Any

from utils.s3_helper import upload_image_to_s3


def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda handler for uploading images to S3.
    
    Endpoint: POST /image/upload
    Expected body: JSON with 'imageBytes' (base64 encoded) and 'imageFileExtension'
    """
    # API Gateway HTTP API v2 format
    body = event.get('body', '{}')
    
    # Handle base64 encoded body if needed
    if event.get('isBase64Encoded', False) and body:
        body = base64.b64decode(body).decode('utf-8')
    
    try:
        # Parse body if it's a string
        if isinstance(body, str):
            body = json.loads(body) if body else {}
        
        # Get image bytes and extension
        image_bytes_base64 = body.get('imageBytes')
        image_file_extension = body.get('imageFileExtension', '.jpg')
        
        if not image_bytes_base64:
            return error_response(400, "Missing required field: imageBytes")
        
        # Decode base64 image bytes
        try:
            image_bytes = base64.b64decode(image_bytes_base64)
        except Exception as e:
            return error_response(400, f"Invalid base64 encoding: {str(e)}")
        
        # Validate extension
        if not image_file_extension.startswith('.'):
            image_file_extension = '.' + image_file_extension
        
        # Get bucket name from environment
        bucket_name = os.environ.get('S3_BUCKET')
        if not bucket_name:
            return error_response(500, "S3_BUCKET environment variable not set")
        
        # Generate unique image ID (UUID)
        image_id = str(uuid.uuid4())
        
        # Create file name with extension
        file_name = f"{image_id}{image_file_extension}"
        
        # Determine content type from extension
        content_type = get_content_type(image_file_extension)
        
        # Upload to S3
        try:
            image_url = upload_image_to_s3(
                file_content=image_bytes,
                bucket_name=bucket_name,
                file_name=file_name,
                content_type=content_type
            )
            
            return success_response(200, {
                'imageUrl': image_url,
                'imageId': image_id
            })
        except Exception as e:
            print(f"Error uploading image to S3: {str(e)}")
            return error_response(500, f"Failed to upload image: {str(e)}")
    
    except json.JSONDecodeError:
        return error_response(400, "Invalid JSON in request body")
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(500, f"Internal server error: {str(e)}")


def get_content_type(extension: str) -> str:
    """
    Get content type from file extension.
    
    Args:
        extension: File extension (e.g., '.jpg', '.png')
    
    Returns:
        Content type string (e.g., 'image/jpeg')
    """
    content_types = {
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.png': 'image/png',
        '.gif': 'image/gif',
        '.webp': 'image/webp'
    }
    
    return content_types.get(extension.lower(), 'image/jpeg')


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

