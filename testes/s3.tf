provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "meu-bucket-s3"  # Substitua pelo nome desejado para o bucket
  acl    = "private"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/meu-lambda-function-role"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::meu-bucket-s3/*"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "example_lambda" {
  function_name = "meu-lambda-function"  # Substitua pelo nome desejado para a função do Lambda
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.example_role.arn
  filename      = "example_lambda.zip"
  source_code_hash = filebase64sha256("example_lambda.zip")
}

resource "aws_iam_role" "example_role" {
  name = "meu-lambda-function-role"  # Substitua pelo nome desejado para a função do IAM

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
