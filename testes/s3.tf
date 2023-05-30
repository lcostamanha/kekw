##################### bucket os-prod-application-artifacts #####################

resource "aws_s3_bucket" "os-prod-application-artifacts" {
  bucket = "os-prod-application-artifacts"
  acl = "private"
  versioning {
    enabled = false
  }

  tags = {
    Name = "os-prod-application-artifacts"
  }

}

resource "aws_s3_bucket_public_access_block" "public_access_block-3" {
  bucket = aws_s3_bucket.os-prod-application-artifacts.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "os-prod-application-artifacts" {
  bucket = aws_s3_bucket.os-prod-application-artifacts.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DelegateS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::166607387349:role/role-infraestrutura",
                    "arn:aws:iam::166607387349:role/terraform-os-dev-jenkins"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::os-prod-application-artifacts/*",
                "arn:aws:s3:::os-prod-application-artifacts"
            ]
        }
    ]
}
POLICY
}
