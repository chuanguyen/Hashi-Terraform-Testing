# module "lambda_api_gateway_getPerson" {
#     source = "./modules/aws_lambda_api_server_integration/"

#     lambda_function_file_path = "./AWS-Lambda-API-Gateway.py"
#     lambda_function_runtime = "python3.11"
#     lambda_function_handler = "AWS-Lambda-API-Gateway.lambda_handler"
#     api_gateway_name = "Terraform-Person-Module"
#     api_gateway_description = "Created by a module"
# }
