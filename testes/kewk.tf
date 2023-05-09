resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_configuration = aws_launch_configuration.example.id
  min_size             = 1
  max_size             = 3

  # Use spot instances for the workers
  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy = "prioritized"
      on_demand_base_capacity       = 0
      spot_allocation_strategy      = "capacity-optimized"
    }

    launch_template {
      id      = aws_launch_template.example.id
      version = "$Latest"
    }
  }

  # Use a warm pool for the workers
  warm_pool {
    min_size     = 1
    max_size     = 2
    pool_state   = "stopped"
    purge_policy = "OldestInstance"
  }
}


############################################################################################################

lammmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm



import boto3
import json
import os
import pandas as pd

TABLE_NAME = os.environ.get("DDB_TABLE_NAME")
OUTPUT_BUCKET = os.environ.get("BUCKET_NAME")
TEMP_FILENAME = '/tmp/export.csv'
OUTPUT_KEY = 'export.csv'

s3_resource = boto3.resource('s3')
dynamodb_resource = boto3.resource('dynamodb')
table = dynamodb_resource.Table(TABLE_NAME)


def lambda_handler(event, context):
    response = table.scan()
    df = pd.DataFrame(response['Items'])
    df.to_csv(TEMP_FILENAME, index=False, header=True)

    # Upload temp file to S3
    s3_resource.Bucket(OUTPUT_BUCKET).upload_file(TEMP_FILENAME, OUTPUT_KEY)

    return {
        'statusCode': 200,
        'headers': {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": True,
            "content-type": "application/json"
        },
        'body': json.dumps('OK')
    }
