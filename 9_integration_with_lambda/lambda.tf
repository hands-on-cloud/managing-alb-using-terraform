locals {
  lambda_source_dir = "${path.module}/lambdas/password_generator"
  lambda_archive    = "${path.module}/lambdas/password_generator.zip"
}

# Data resource to archive Lambda function code
data "archive_file" "lambda_zip" {
  source_dir  = local.lambda_source_dir
  output_path = local.lambda_archive
  type        = "zip"
}

# Lambda function policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.prefix}-lambda-policy"
  description = "${local.prefix}-lambda-policy"

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
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Lambda function role
resource "aws_iam_role" "iam_for_terraform_lambda" {
  name = "${local.prefix}-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Role to Policy attachment
resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
  role = aws_iam_role.iam_for_terraform_lambda.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function declaration
resource "aws_lambda_function" "password_generator" {
  filename = local.lambda_archive
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "${local.prefix}-lambda"
  role = aws_iam_role.iam_for_terraform_lambda.arn
  handler = "index.lambda_handler"
  runtime = "python3.9"
}

# CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_loggroup" {
  name = "/aws/lambda/${aws_lambda_function.password_generator.function_name}"
  retention_in_days = 14
}
