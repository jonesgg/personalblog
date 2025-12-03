# DynamoDB Table for Blogposts
resource "aws_dynamodb_table" "blogpost" {
  name           = "blogpost"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "slug"

  attribute {
    name = "slug"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-blogpost"
    Environment = var.environment
  }
}

# DynamoDB Table for Portfolio
resource "aws_dynamodb_table" "portfolio" {
  name           = "portfolio"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-portfolio"
    Environment = var.environment
  }
}

# DynamoDB Table for Experience
resource "aws_dynamodb_table" "experience" {
  name           = "experience"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-experience"
    Environment = var.environment
  }
}

