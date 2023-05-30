provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
}

resource "aws_s3_bucket" "example" {
  bucket = "meu-bucket-s3"
  acl    = "private"
}

resource "aws_lambda_function" "example" {
  function_name = "meu-lambda-function"
  # Configurações do Lambda

  # ...

  # Adicione a permissão do Lambda para acessar o bucket S3
  provisioned_concurrency_config {
    function_name    = aws_lambda_function.example.function_name
    provisioned_concurrent_executions = 1
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "AllowLambdaAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::meu-bucket-s3/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_lambda_function.example.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
