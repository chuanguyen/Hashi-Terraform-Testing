variable "lambda_function_file_path" {
    type = string
    description = "Path to Lambda function file that should be zipped"
}

variable "lambda_function_runtime" {
    type = string
    description = "Runtime environment for the Lambda function"
}

variable "lambda_function_handler" {
    type = string
    description = "Handler for the Lambda function"
}

variable "api_gateway_name" {
    type = string
}

variable "api_gateway_description" {
    type = string
    default = "Managed by Terraform"
}

variable "api_gateway_protocol_type" {
    type = string
    default = "HTTP"
}