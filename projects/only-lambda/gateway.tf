resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "Api Gateway for Only Lambda"
  description = "Api Gateway created when testing only lambda terraform project"
}

resource "aws_api_gateway_account" "api-gateway-only-lambda-account" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
  resource_id = "${aws_api_gateway_method.only-lambda.resource_id}"
  http_method = "${aws_api_gateway_method.only-lambda.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.terraform_lambda_func.invoke_arn}"
}

# To accept requests at the root of the url
/*
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.api-gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.api-gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.terraform_lambda_func.invoke_arn}"
}
*/

resource "aws_api_gateway_deployment" "api-gateway-deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    #aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
  stage_name  = "staging"
}

resource "aws_api_gateway_method_settings" "api-gateway-settings" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  stage_name  = aws_api_gateway_deployment.api-gateway-deployment.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

output "base_url" {
  value = "${aws_api_gateway_deployment.api-gateway-deployment.invoke_url}"
}
