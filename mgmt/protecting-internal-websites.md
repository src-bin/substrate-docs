# Protecting internal websites

The tools Substrate manages under your Intranet (the Accounts page that facilitates logging into the AWS Console, the Credential Factory, and the Instance Factory) are far from the only internal tools you're going to operate as a part of your business. You should take advantage of your Intranet to protect your other internal tools with SSO, HTTP Strict Transport Security, a separate cookie scope, and a robust serverless exterior courtesy of AWS API Gateway.

There are two main strategies for adding new features to your Intranet which should serve use cases as wide-ranging as Lambda functions in your admin account to load-balanced EC2 deployments in a service account. These strategies are both available to you after [deciding where to host](../ref/internal-tools.md) each particular internal tool.

## Integrating with API Gateway and Lambda in `modules/intranet/regional`

The easiest place to put Intranet extensions is in `modules/intranet/regional` because all the scaffolding is already present and it'll transparently handle multiple regions. Add resources such as these to a new file (and not `main.tf`, which is overwritten per the comment on its first line):

```
resource "aws_api_gateway_integration" "GET-wildcard" {
  credentials             = data.aws_iam_role.apigateway.arn
  http_method             = aws_api_gateway_method.GET-example.http_method
  integration_http_method = "POST" # always "POST" even if you specify "GET" everywhere else
  passthrough_behavior    = "NEVER"
  resource_id             = aws_api_gateway_resource.example.id
  rest_api_id             = aws_api_gateway_rest_api.intranet.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example.invoke_arn
}

resource "aws_api_gateway_method" "GET-example" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.substrate.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.intranet.id
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = var.parent_resource_id
  path_part   = "example"
  rest_api_id = aws_api_gateway_rest_api.intranet.id
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/example"
  retention_in_days = 1
}

resource "aws_lambda_function" "example" {
  depends_on       = [aws_cloudwatch_log_group.example]
  function_name    = "example"
  // ...
}

resource "aws_lambda_permission" "example" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
}
```

It is also possible to put the Lambda function in another AWS account but you'll need to grant your admin account(s) permission to invoke it with additional `aws_lambda_permission` resources.

## Integrating with API Gateway and Lambda in your own module

If you'd prefer to stay out of `modules/intranet`, you can create your own module (using `substrate create-terraform-module`, if you like) and reference it from `root-modules/admin/*/*` (except `global`) thus:

```
module "intranet-extensions" {
  authorizer_id           = module.intranet.authorizer_id
  integration_credentials = module.intranet.integration_credentials
  rest_api_id             = module.intranet.rest_api_id
  root_resource_id        = module.intranet.root_resource_id

  source = "../../../../modules/intranet-extensions"
}
```

Place your API Gateway and Lambda resources there as shown above but use `var.authorizer_id`, etc. in place of the direct references that were possible within `modules/intranet/regional`.

## Proxying to internal websites

Not everything is, can be, or should be a Lambda function, though, and these internal services are just as worthy of protection. Substrate ships a proxy that makes it easy to create secure network paths to anything running in your AWS organization. In a new file in `modules/intranet/regional`, add a resource like this for each internal service you're protecting and proxying.

```
module "proxy-example" {
  apigateway_execution_arn = aws_api_gateway_deployment.intranet.execution_arn
  apigateway_role_arn      = data.aws_iam_role.apigateway.arn
  authorizer_id            = aws_api_gateway_authorizer.substrate.id
  lambda_role_arn          = data.aws_iam_role.intranet.arn
  parent_resource_id       = aws_api_gateway_rest_api.intranet.root_resource_id
  proxy_destination_url    = "http://TODO"
  proxy_path_prefix        = "example"
  rest_api_id              = aws_api_gateway_rest_api.intranet.id
  security_group_ids       = ["TODO"]
  strip_path_prefix        = true
  subnet_ids               = module.substrate.public_subnet_ids

  source = "./proxy"
}
```

The majority of the input variables are just about how the proxy is wired into the Intranet's API Gateway. You must provide a `proxy_destination_url` (where requests are proxied) and `proxy_path_prefix` (the first path component of the Intranet URLs that are proxied). You probably want to provide `security_group_ids` and `subnet_ids` in order to place the proxy Lambda function in a network position that's actually able to reach the internal service. (After all, if it's reachable from the Internet, making it _also_ accessible via your Intranet doesn't offer much in the way of additional protection.)

## Identifying users on websites protected by the Intranet

When the Intranet passes a request to a Lambda function as an event, the identity of the authenticated user is available in `event.requestContext.authorizer.principalId`.

That same identity is made available to internal websites in the `X-Substrate-Intranet-Proxy-Principal` header.

In most cases, the principal is given as an email address though its exact format depends on your identity provider and its configuration.

Jenkins users can use the [Reverse Proxy Auth Plugin](https://plugins.jenkins.io/reverse-proxy-auth-plugin/) to accept the `X-Substrate-Intranet-Proxy-Principal` header. If you take this path you _must_ set both Header User Name and Header Groups Name to `X-Substrate-Intranet-Proxy-Principal` to avoid introducing a security vulnerability and you must be OK with not being able to use Jenkins groups in any meaningful sense.
