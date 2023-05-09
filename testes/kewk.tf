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

import json
import traceback
import boto3

def lambda_handler(event, context):
    """
    Export Dynamodb to s3 (JSON)
    """

    statusCode = 200
    statusMessage = 'Success'

    try:
        # parse the payload
        tableName = event['tableName']
        s3_bucket = event['s3_bucket']
        s3_object = event['s3_object']
        filename = event['filename']

        # scan the dynamodb
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(tableName)

        response = table.scan()
        data = response['Items']

        # maximum data set limit is 1MB
        # so we need to have this additional step
        while 'LastEvaluatedKey' in response:
            response = dynamodb.scan(
                TableName=tableName,
                Select='ALL_ATTRIBUTES',
                ExclusiveStartKey=response['LastEvaluatedKey'])

            data.extend(response['Items'])
            
        # export JSON to s3 bucket
        s3 = boto3.resource('s3')
        s3.Object(s3_object, s3_object + filename).put(Body=json.dumps(data))

        except Exception as e:
            statusCode = 400
            statusMessage =  traceback.format_exc()

        return {
            "statusCode": statusCode,
            "status": statusMessage
        }
