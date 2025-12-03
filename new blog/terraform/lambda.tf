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

resource "null_resource" "portfolio_create_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/portfolio/portfolio-create/handler.py")
    utils_hash    = filemd5("${path.module}/../src/lambda/portfolio/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/portfolio-create-temp
      cp -r ${path.module}/../src/lambda/portfolio/portfolio-create/* ${path.module}/.terraform/portfolio-create-temp/
      cp -r ${path.module}/../src/lambda/portfolio/utils ${path.module}/.terraform/portfolio-create-temp/
    EOT
  }
}

resource "null_resource" "portfolio_get_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/portfolio/portfolio-get/handler.py")
    utils_hash   = filemd5("${path.module}/../src/lambda/portfolio/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/portfolio-get-temp
      cp -r ${path.module}/../src/lambda/portfolio/portfolio-get/* ${path.module}/.terraform/portfolio-get-temp/
      cp -r ${path.module}/../src/lambda/portfolio/utils ${path.module}/.terraform/portfolio-get-temp/
    EOT
  }
}

resource "null_resource" "portfolio_list_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/portfolio/portfolio-list/handler.py")
    utils_hash   = filemd5("${path.module}/../src/lambda/portfolio/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/portfolio-list-temp
      cp -r ${path.module}/../src/lambda/portfolio/portfolio-list/* ${path.module}/.terraform/portfolio-list-temp/
      cp -r ${path.module}/../src/lambda/portfolio/utils ${path.module}/.terraform/portfolio-list-temp/
    EOT
  }
}

# Archive Lambda function code
data "archive_file" "portfolio_create_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/portfolio-create-temp"
  output_path = "${path.module}/.terraform/portfolio-create.zip"
  depends_on  = [null_resource.portfolio_create_package]
}

data "archive_file" "portfolio_get_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/portfolio-get-temp"
  output_path = "${path.module}/.terraform/portfolio-get.zip"
  depends_on  = [null_resource.portfolio_get_package]
}

data "archive_file" "portfolio_list_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/portfolio-list-temp"
  output_path = "${path.module}/.terraform/portfolio-list.zip"
  depends_on  = [null_resource.portfolio_list_package]
}

resource "null_resource" "resume_create_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/resume/resume-create/handler.py")
    utils_hash    = filemd5("${path.module}/../src/lambda/resume/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/resume-create-temp
      cp -r ${path.module}/../src/lambda/resume/resume-create/* ${path.module}/.terraform/resume-create-temp/
      cp -r ${path.module}/../src/lambda/resume/utils ${path.module}/.terraform/resume-create-temp/
    EOT
  }
}

resource "null_resource" "resume_list_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/resume/resume-list/handler.py")
    utils_hash   = filemd5("${path.module}/../src/lambda/resume/utils/dynamodb_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/resume-list-temp
      cp -r ${path.module}/../src/lambda/resume/resume-list/* ${path.module}/.terraform/resume-list-temp/
      cp -r ${path.module}/../src/lambda/resume/utils ${path.module}/.terraform/resume-list-temp/
    EOT
  }
}

# Archive Lambda function code
data "archive_file" "resume_create_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/resume-create-temp"
  output_path = "${path.module}/.terraform/resume-create.zip"
  depends_on  = [null_resource.resume_create_package]
}

data "archive_file" "resume_list_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/resume-list-temp"
  output_path = "${path.module}/.terraform/resume-list.zip"
  depends_on  = [null_resource.resume_list_package]
}

resource "null_resource" "image_upload_package" {
  triggers = {
    handler_hash = filemd5("${path.module}/../src/lambda/image/image-upload/handler.py")
    utils_hash    = filemd5("${path.module}/../src/lambda/image/utils/s3_helper.py")
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/.terraform/image-upload-temp
      cp -r ${path.module}/../src/lambda/image/image-upload/* ${path.module}/.terraform/image-upload-temp/
      cp -r ${path.module}/../src/lambda/image/utils ${path.module}/.terraform/image-upload-temp/
    EOT
  }
}

# Archive Lambda function code
data "archive_file" "image_upload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/image-upload-temp"
  output_path = "${path.module}/.terraform/image-upload.zip"
  depends_on  = [null_resource.image_upload_package]
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

# Lambda Function for Portfolio Create
resource "aws_lambda_function" "portfolio_create" {
  filename         = data.archive_file.portfolio_create_zip.output_path
  function_name    = "${var.project_name}-portfolio-create"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.portfolio_create_zip.output_base64sha256
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
    Name        = "${var.project_name}-portfolio-create"
    Environment = var.environment
  }
}

# Lambda Function for Portfolio Get
resource "aws_lambda_function" "portfolio_get" {
  filename         = data.archive_file.portfolio_get_zip.output_path
  function_name    = "${var.project_name}-portfolio-get"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.portfolio_get_zip.output_base64sha256
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
    Name        = "${var.project_name}-portfolio-get"
    Environment = var.environment
  }
}

# Lambda Function for Portfolio List
resource "aws_lambda_function" "portfolio_list" {
  filename         = data.archive_file.portfolio_list_zip.output_path
  function_name    = "${var.project_name}-portfolio-list"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.portfolio_list_zip.output_base64sha256
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
    Name        = "${var.project_name}-portfolio-list"
    Environment = var.environment
  }
}

# Lambda Function for Resume Create
resource "aws_lambda_function" "resume_create" {
  filename         = data.archive_file.resume_create_zip.output_path
  function_name    = "${var.project_name}-resume-create"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.resume_create_zip.output_base64sha256
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
    Name        = "${var.project_name}-resume-create"
    Environment = var.environment
  }
}

# Lambda Function for Resume List
resource "aws_lambda_function" "resume_list" {
  filename         = data.archive_file.resume_list_zip.output_path
  function_name    = "${var.project_name}-resume-list"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.resume_list_zip.output_base64sha256
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
    Name        = "${var.project_name}-resume-list"
    Environment = var.environment
  }
}

# Lambda Function for Image Upload
resource "aws_lambda_function" "image_upload" {
  filename         = data.archive_file.image_upload_zip.output_path
  function_name    = "${var.project_name}-image-upload"
  role            = aws_iam_role.lambda.arn
  handler         = "handler.lambda_handler"
  source_code_hash = data.archive_file.image_upload_zip.output_base64sha256
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
    Name        = "${var.project_name}-image-upload"
    Environment = var.environment
  }
}

