output "api_gateway_url" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "blogpost_api_url" {
  description = "Blogpost API endpoint URL"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/blogpost"
}

output "portfolio_api_url" {
  description = "Portfolio API endpoint URL"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/portfolio"
}

output "resume_api_url" {
  description = "Resume API endpoint URL"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/resume"
}

output "s3_bucket_name" {
  description = "S3 bucket name for images"
  value       = aws_s3_bucket.images.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for images"
  value       = aws_s3_bucket.images.arn
}

output "dynamodb_tables" {
  description = "DynamoDB table names"
  value = {
    blogpost  = aws_dynamodb_table.blogpost.name
    portfolio = aws_dynamodb_table.portfolio.name
    experience = aws_dynamodb_table.experience.name
  }
}

output "lambda_functions" {
  description = "Lambda function names"
  value = {
    blogpost_create = aws_lambda_function.blogpost_create.function_name
    blogpost_get    = aws_lambda_function.blogpost_get.function_name
    blogpost_list   = aws_lambda_function.blogpost_list.function_name
    portfolio        = aws_lambda_function.portfolio.function_name
    resume           = aws_lambda_function.resume.function_name
  }
}

