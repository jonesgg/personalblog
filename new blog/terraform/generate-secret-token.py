#!/usr/bin/env python3
"""
Generate a secure secret token for admin authentication.

This script generates a cryptographically secure random token. The token should
be used as the SECRET_TOKEN value in terraform.tfvars and also used in the
x-admin-token header when making API requests.

Workflow:
1. Run: python3 generate-secret-token.py --format terraform --show-plain
2. Save the token securely (you'll need it for API requests)
3. Copy the token to terraform.tfvars as secret_token
4. Use the same token in the x-admin-token header when calling create APIs

Usage:
    python3 generate-secret-token.py --show-plain
    python3 generate-secret-token.py --length 64 --format terraform --show-plain
    python3 generate-secret-token.py --format terraform
"""

import secrets
import argparse
import sys


def generate_token(length: int = 32) -> str:
    """
    Generate a cryptographically secure random token.
    
    Args:
        length: Length of the token in bytes (default: 32)
    
    Returns:
        A hexadecimal string token (2x the length in characters)
    """
    return secrets.token_hex(length)


def main():
    parser = argparse.ArgumentParser(
        description='Generate a secure secret token for admin authentication',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 generate-secret-token.py
  python3 generate-secret-token.py --length 64
  python3 generate-secret-token.py --format terraform
  python3 generate-secret-token.py --length 32 --format terraform
        """
    )
    
    parser.add_argument(
        '--length',
        type=int,
        default=32,
        help='Token length in bytes (default: 32, produces 64 hex characters)'
    )
    
    parser.add_argument(
        '--format',
        choices=['plain', 'terraform'],
        default='plain',
        help='Output format: plain (just the hash) or terraform (terraform.tfvars format)'
    )
    
    parser.add_argument(
        '--show-plain',
        action='store_true',
        help='Also show the plain token (for initial setup - keep it secure!)'
    )
    
    args = parser.parse_args()
    
    if args.length < 16:
        print("Warning: Token length less than 16 bytes is not recommended for security.", file=sys.stderr)
    
    # Generate token
    token = generate_token(args.length)
    
    if args.show_plain:
        print("Token (keep this secure! Use this in both terraform.tfvars and x-admin-token header):", file=sys.stderr)
        print(token, file=sys.stderr)
        print("", file=sys.stderr)
    
    if args.format == 'terraform':
        print(f'secret_token = "{token}"')
    else:
        print(token)


if __name__ == '__main__':
    main()

