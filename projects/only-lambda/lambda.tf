locals {
  function_file = "${path.module}/function/test-function.zip"
}
resource "aws_iam_role" "lambda_role" {
  name   = "lambda-function-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
  name         = "lambda-function-policy"
  path         = "/"
  description  = "Lambda Function Policy"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/function/"
  output_path = local.function_file
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename                       = local.function_file
  function_name                  = "only-lambda-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "index.lambda_handler"
  runtime                        = "python3.9"
  depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash               = filebase64sha256(local.function_file)
}

// After adding the Api Gateway
resource "aws_api_gateway_resource" "only-lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.api-gateway.root_resource_id}"
  path_part   = "only-lambda"
}

resource "aws_api_gateway_method" "only-lambda" {
  rest_api_id   = "${aws_api_gateway_rest_api.api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.only-lambda.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "api-gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.terraform_lambda_func.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*"
}