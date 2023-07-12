{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction",
                "sqs:*",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:AssociateKmsKey",
                "ec2:Describe*",
                "ec2:*",
                "s3:Get*",
                "s3:List*",
                "s3:Put*",
                "secretsmanager:GetSecretValue",
                "ssm:GetParameter",
                "ssm:GetParametersByPath",
                "appconfig:GetLatestConfiguration",
                "appconfig:StartConfigurationSession",
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey",
                "autoscaling:DescribeAutoScalingGroups",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "ec2:Describe*",
                "glue:BatchCreatePartition",
                "glue:BatchDeletePartition",
                "glue:BatchUpdatePartition",
                "glue:CreateDevEndpoint",
                "glue:CreatePartition",
                "glue:CreateSecurityConfiguration",
                "glue:DeletePartition",
                "glue:GetSecurityConfiguration",
                "glue:GetTable",
                "glue:GetPartitions",
                "glue:GetDatabases",
                "glue:GetSchemaVersion",
                "glue:GetWorkflowRuns",
                "glue:GetCrawlerMetrics",
                "glue:GetJobBookmark",
                "glue:GetJob",
                "glue:GetWorkflow",
                "glue:GetConnections",
                "glue:GetCrawlers",
                "glue:GetDevEndpoints",
                "glue:GetTrigger",
                "glue:GetJobRun",
                "glue:GetResourcePolicies",
                "glue:GetTables",
                "glue:UpdatePartition",
                "glue:SearchTables",
                "s3:DeleteObject",
                "s3:GetBucketLocation*",
                "s3:GetBucketAcl*",
                "s3:GetObject*",
                "s3:GetObjectAttributes*",
                "s3:ListBucket*",
                "s3:ListAllMyBuckets*",
                "s3:ListBucketMultipartUploads*",
                "s3:PutObject*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lakeformation:ListPermissions"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "kms:GenerateDataKey",
            "Resource": "ARN_da_chave_KMS"
        }
    ]
}
