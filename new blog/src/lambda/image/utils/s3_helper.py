import boto3
import os
from datetime import datetime
from typing import Optional
import uuid

s3_client = boto3.client('s3')


def upload_image_to_s3(
    file_content: bytes,
    bucket_name: str,
    file_name: Optional[str] = None,
    content_type: str = 'image/jpeg',
    folder: Optional[str] = None
) -> str:
    """
    Upload an image to S3 and return its public URL.
    
    Args:
        file_content: Binary content of the image file
        bucket_name: Name of the S3 bucket
        file_name: Optional custom file name. If not provided, generates a UUID-based name
        content_type: MIME type of the image (default: image/jpeg)
        folder: Optional folder path within the bucket (e.g., 'blog-images', 'portfolio-images')
    
    Returns:
        Public URL of the uploaded image
    """
    # Generate file name if not provided
    if not file_name:
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        unique_id = str(uuid.uuid4())[:8]
        file_name = f"{timestamp}_{unique_id}"
    
    # Construct the S3 key (path)
    if folder:
        s3_key = f"{folder}/{file_name}"
    else:
        s3_key = file_name
    
    # Upload to S3
    # Note: ACLs are disabled on new S3 buckets, so we rely on bucket policy for public access
    s3_client.put_object(
        Bucket=bucket_name,
        Key=s3_key,
        Body=file_content,
        ContentType=content_type
    )
    
    # Construct and return the public URL
    region = s3_client.meta.region_name
    url = f"https://{bucket_name}.s3.{region}.amazonaws.com/{s3_key}"
    
    return url


def delete_image_from_s3(bucket_name: str, s3_key: str) -> bool:
    """
    Delete an image from S3.
    
    Args:
        bucket_name: Name of the S3 bucket
        s3_key: S3 key (path) of the image to delete
    
    Returns:
        True if successful, False otherwise
    """
    try:
        s3_client.delete_object(Bucket=bucket_name, Key=s3_key)
        return True
    except Exception as e:
        print(f"Error deleting image from S3: {str(e)}")
        return False

