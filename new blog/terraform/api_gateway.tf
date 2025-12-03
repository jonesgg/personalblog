# API Gateway REST API
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  description   = "API Gateway for ${var.project_name}"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
    max_age       = 300
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

# API Gateway Integration for Blogpost Create
resource "aws_apigatewayv2_integration" "blogpost_create" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.blogpost_create.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration for Blogpost Get
resource "aws_apigatewayv2_integration" "blogpost_get" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.blogpost_get.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration for Blogpost List
resource "aws_apigatewayv2_integration" "blogpost_list" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.blogpost_list.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Blogpost - Create (POST)
resource "aws_apigatewayv2_route" "blogpost_create" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /blogpost"
  target    = "integrations/${aws_apigatewayv2_integration.blogpost_create.id}"
}

# API Gateway Route for Blogpost - Get by slug (GET)
resource "aws_apigatewayv2_route" "blogpost_get" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /blogpost/{slug}"
  target    = "integrations/${aws_apigatewayv2_integration.blogpost_get.id}"
}

# API Gateway Route for Blogpost - List all (GET)
resource "aws_apigatewayv2_route" "blogpost_list" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /blogpost"
  target    = "integrations/${aws_apigatewayv2_integration.blogpost_list.id}"
}

# API Gateway Integration for Portfolio Create
resource "aws_apigatewayv2_integration" "portfolio_create" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.portfolio_create.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration for Portfolio Get
resource "aws_apigatewayv2_integration" "portfolio_get" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.portfolio_get.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration for Portfolio List
resource "aws_apigatewayv2_integration" "portfolio_list" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.portfolio_list.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Portfolio - Create (POST)
resource "aws_apigatewayv2_route" "portfolio_create" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /portfolio"
  target    = "integrations/${aws_apigatewayv2_integration.portfolio_create.id}"
}

# API Gateway Route for Portfolio - Get by slug (GET)
resource "aws_apigatewayv2_route" "portfolio_get" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /portfolio/{slug}"
  target    = "integrations/${aws_apigatewayv2_integration.portfolio_get.id}"
}

# API Gateway Route for Portfolio - List all (GET)
resource "aws_apigatewayv2_route" "portfolio_list" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /portfolio"
  target    = "integrations/${aws_apigatewayv2_integration.portfolio_list.id}"
}

# API Gateway Integration for Resume Create
resource "aws_apigatewayv2_integration" "resume_create" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.resume_create.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration for Resume List
resource "aws_apigatewayv2_integration" "resume_list" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.resume_list.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Resume - Create (POST)
resource "aws_apigatewayv2_route" "resume_create" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /resume"
  target    = "integrations/${aws_apigatewayv2_integration.resume_create.id}"
}

# API Gateway Route for Resume - List all (GET)
resource "aws_apigatewayv2_route" "resume_list" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /resume"
  target    = "integrations/${aws_apigatewayv2_integration.resume_list.id}"
}

# API Gateway Integration for Image Upload
resource "aws_apigatewayv2_integration" "image_upload" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.image_upload.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Image Upload (POST)
resource "aws_apigatewayv2_route" "image_upload" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /image/upload"
  target    = "integrations/${aws_apigatewayv2_integration.image_upload.id}"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true

  default_route_settings {
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }

  tags = {
    Name        = "${var.project_name}-api-stage"
    Environment = var.environment
  }
}

# Lambda Permissions for API Gateway
resource "aws_lambda_permission" "blogpost_create_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.blogpost_create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "blogpost_get_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.blogpost_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "blogpost_list_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.blogpost_list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "portfolio_create_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portfolio_create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "portfolio_get_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portfolio_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "portfolio_list_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portfolio_list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "resume_create_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resume_create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "resume_list_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resume_list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "image_upload_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_upload.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

