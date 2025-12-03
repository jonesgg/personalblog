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

# API Gateway Integration for Portfolio
resource "aws_apigatewayv2_integration" "portfolio" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.portfolio.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Portfolio - List/Create
resource "aws_apigatewayv2_route" "portfolio" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /portfolio"
  target    = "integrations/${aws_apigatewayv2_integration.portfolio.id}"
}

# API Gateway Route for Portfolio - Get/Update/Delete by ID
resource "aws_apigatewayv2_route" "portfolio_id" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /portfolio/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.portfolio.id}"
}

# API Gateway Integration for Resume
resource "aws_apigatewayv2_integration" "resume" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.resume.invoke_arn
  integration_method = "POST"
}

# API Gateway Route for Resume - List/Create
resource "aws_apigatewayv2_route" "resume" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /resume"
  target    = "integrations/${aws_apigatewayv2_integration.resume.id}"
}

# API Gateway Route for Resume - Get/Update/Delete by ID
resource "aws_apigatewayv2_route" "resume_id" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /resume/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.resume.id}"
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

resource "aws_lambda_permission" "portfolio_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portfolio.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "resume_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resume.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

