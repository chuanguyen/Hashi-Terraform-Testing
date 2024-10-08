output "api_gateway_id" {
    value = aws_apigatewayv2_api.AWS-Lambda-API-Gateway.id
}

output "api_gateway_arn" {
    value = aws_apigatewayv2_api.AWS-Lambda-API-Gateway.arn
}

output "api_gateway_stage_default_invoke_url" {
    value = aws_apigatewayv2_stage.default.invoke_url
}


output "lambda_function_arn" {
    value = aws_lambda_function.AWS-Lambda-API-Gateway.arn
}

output "lambda_function_invoke_arn" {
    value = aws_lambda_function.AWS-Lambda-API-Gateway.invoke_arn
}

output "lambda_function_iam_role_arn" {
    value = aws_iam_role.AWS-Lambda-API-Gateway.arn
}

output "lambda_function_file_path_no_extension" {
    value = local.lambda_function_file_path_no_extension
}

output "lambda_function_name" {
    value = local.lambda_function_function_name
}