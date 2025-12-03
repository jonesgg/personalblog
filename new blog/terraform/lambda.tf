# Prepare Lambda packages with shared utils
# We use null_resource to copy utils into each function directory before packaging
resource "null_resource" "blogpost_create_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/blogpost/blogpost-create/handler.py")
    utils_hash    = filemd5("${path.module}/../src/lambda/blogpost/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/blogpost-create-temp
      cp -r ${path.module}/../src/lambda/blogpost/blogpost-create/* ${path.module}/.terraform/blogpost-create-temp/
      cp -r ${path.module}/../src/lambda/blogpost/utils ${path.module}/.terraform/blogpost-create-temp/
    EOT
  }
}

resource "null_resource" "blogpost_get_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/blogpost/blogpost-get/handler.py")
    utils_hash   = filemd5("${path.module}/../src/lambda/blogpost/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/blogpost-get-temp
      cp -r ${path.module}/../src/lambda/blogpost/blogpost-get/* ${path.module}/.terraform/blogpost-get-temp/
      cp -r ${path.module}/../src/lambda/blogpost/utils ${path.module}/.terraform/blogpost-get-temp/
    EOT
  }
}

resource "null_resource" "blogpost_list_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/blogpost/blogpost-list/handler.py")
    utils_hash   = filemd5("${path.module}/../src/lambda/blogpost/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/blogpost-list-temp
      cp -r ${path.module}/../src/lambda/blogpost/blogpost-list/* ${path.module}/.terraform/blogpost-list-temp/
      cp -r ${path.module}/../src/lambda/blogpost/utils ${path.module}/.terraform/blogpost-list-temp/
    EOT
  }
}

# Archive Lambda function code
data "archive_file" "blogpost_create_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/blogpost-create-temp"
  output_path = "${path.module}/.terraform/blogpost-create.zip"
  depends_on  = [null_resource.blogpost_create_package]
}

data "archive_file" "blogpost_get_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/blogpost-get-temp"
  output_path = "${path.module}/.terraform/blogpost-get.zip"
  depends_on  = [null_resource.blogpost_get_package]
}

data "archive_file" "blogpost_list_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/blogpost-list-temp"
  output_path = "${path.module}/.terraform/blogpost-list.zip"
  depends_on  = [null_resource.blogpost_list_package]
}

data "archive_file" "portfolio_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda/portfolio"
  output_path = "${path.module}/.terraform/portfolio.zip"
}

data "archive_file" "resume_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda/resume"
  output_path = "${path.module}/.terraform/resume.zip"
}

# Lambda Function for Blogpost Create
resource "aws_lambda_function" "blogpost_create" {
  filename         = data.archive_file.blogpost_create_zip.output_path
  function_name    = "${var.project_name}-blogpost-create"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.blogpost_create_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      BLOGPOST_TABLE  = aws_dynamodb_table.blogpost.name
      PORTFOLIO_TABLE = aws_dynamodb_table.portfolio.name
      EXPERIENCE_TABLE = aws_dynamodb_table.experience.name
      S3_BUCKET       = aws_s3_bucket.images.id
    }
  }

  tags = {
    Name        = "${var.project_name}-blogpost-create"
    Environment = var.environment
  }
}

# Lambda Function for Blogpost Get
resource "aws_lambda_function" "blogpost_get" {
  filename         = data.archive_file.blogpost_get_zip.output_path
  function_name    = "${var.project_name}-blogpost-get"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.blogpost_get_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      BLOGPOST_TABLE  = aws_dynamodb_table.blogpost.name
      PORTFOLIO_TABLE = aws_dynamodb_table.portfolio.name
      EXPERIENCE_TABLE = aws_dynamodb_table.experience.name
      S3_BUCKET       = aws_s3_bucket.images.id
    }
  }

  tags = {
    Name        = "${var.project_name}-blogpost-get"
    Environment = var.environment
  }
}

# Lambda Function for Blogpost List
resource "aws_lambda_function" "blogpost_list" {
  filename         = data.archive_file.blogpost_list_zip.output_path
  function_name    = "${var.project_name}-blogpost-list"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.blogpost_list_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      BLOGPOST_TABLE  = aws_dynamodb_table.blogpost.name
      PORTFOLIO_TABLE = aws_dynamodb_table.portfolio.name
      EXPERIENCE_TABLE = aws_dynamodb_table.experience.name
      S3_BUCKET       = aws_s3_bucket.images.id
    }
  }

  tags = {
    Name        = "${var.project_name}-blogpost-list"
    Environment = var.environment
  }
}

# Lambda Function for Portfolio API
resource "aws_lambda_function" "portfolio" {
  filename         = data.archive_file.portfolio_zip.output_path
  function_name    = "${var.project_name}-portfolio-api"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.portfolio_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      BLOGPOST_TABLE  = aws_dynamodb_table.blogpost.name
      PORTFOLIO_TABLE = aws_dynamodb_table.portfolio.name
      EXPERIENCE_TABLE = aws_dynamodb_table.experience.name
      S3_BUCKET       = aws_s3_bucket.images.id
    }
  }

  tags = {
    Name        = "${var.project_name}-portfolio-api"
    Environment = var.environment
  }
}

# Lambda Function for Resume API
resource "aws_lambda_function" "resume" {
  filename         = data.archive_file.resume_zip.output_path
  function_name    = "${var.project_name}-resume-api"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.resume_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      BLOGPOST_TABLE  = aws_dynamodb_table.blogpost.name
      PORTFOLIO_TABLE = aws_dynamodb_table.portfolio.name
      EXPERIENCE_TABLE = aws_dynamodb_table.experience.name
      S3_BUCKET       = aws_s3_bucket.images.id
    }
  }

  tags = {
    Name        = "${var.project_name}-resume-api"
    Environment = var.environment
  }
}

