data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "AWSLambdaAssumeRole" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

# Assume Role Policy is separate from the other policies I created
resource "aws_iam_role" "AWS-Lambda-API-Gateway" {
  name               = "AWS-Lambda-API-Gateway-Terraform"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaAssumeRole.json
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.AWS-Lambda-API-Gateway.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

locals {
    lambda_function_file_path_no_extension = replace(var.lambda_function_file_path, "/.[^.]*$/", "")
    lambda_function_function_name = basename(local.lambda_function_file_path_no_extension)
}

data "archive_file" "AWS-Lambda-API-Gateway" {
  type        = "zip"
  source_file = var.lambda_function_file_path
  output_path = "${local.lambda_function_file_path_no_extension}.zip"
}

resource "aws_lambda_function" "AWS-Lambda-API-Gateway" {
  filename      = "${local.lambda_function_file_path_no_extension}.zip"
  function_name = basename(local.lambda_function_file_path_no_extension)
  runtime       = var.lambda_function_runtime
  role          = aws_iam_role.AWS-Lambda-API-Gateway.arn
  handler       = var.lambda_function_handler
}

# Create the API gateway
resource "aws_apigatewayv2_api" "AWS-Lambda-API-Gateway" {
  name          = var.api_gateway_name
  description   = var.api_gateway_description
  protocol_type = var.api_gateway_protocol_type
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.AWS-Lambda-API-Gateway.id
  name        = "$default"
  auto_deploy = true
  description = "Default stage (i.e., Production mode)"
}

# Sets up the Lambda function integration

resource "aws_apigatewayv2_integration" "AWS-Lambda-API-Gateway" {
  api_id           = aws_apigatewayv2_api.AWS-Lambda-API-Gateway.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  description               = "Managed by Terraform"
  payload_format_version    = "2.0"

  # Lambda integrations must use HTTP POST method, different from the API Gateway route method
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integration-using-cli.html
  integration_method        = "POST"
  # invoke_arn is specifically referenced to be used for the API Gateway Integration resource
  integration_uri           = aws_lambda_function.AWS-Lambda-API-Gateway.invoke_arn
}

resource "aws_apigatewayv2_route" "AWS-Lambda-API-Gateway" {
  api_id    = aws_apigatewayv2_api.AWS-Lambda-API-Gateway.id
  route_key = "GET /getPerson"

  target = "integrations/${aws_apigatewayv2_integration.AWS-Lambda-API-Gateway.id}"
}

# Grant API Gateway to invoke Lambda function
resource "aws_lambda_permission" "AWS-Lambda-API-Gateway" {
  statement_id  = "allowInvokeFromAPIGatewayRoute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.AWS-Lambda-API-Gateway.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  # execution_arn should be referenced from the gateway as mentioned in documentation
  # Otherwise, API Gateway trigger won't appear in Lambda function console
  source_arn = "${aws_apigatewayv2_api.AWS-Lambda-API-Gateway.execution_arn}/*/*"
}
