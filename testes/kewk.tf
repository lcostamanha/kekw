{
   "TableName": "DynamoDB_Table_name",
   "s3_bucket": "s3_bucket_name",
   "s3_object": "s3_object_name",
   "filename": "output.json"
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
