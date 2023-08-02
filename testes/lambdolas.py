import boto3
import datetime
import pandas as pd
import os

def lambda_handler(event, context):
    dynamodb = boto3.client('dynamodb')
    s3 = boto3.client('s3')
    table_name = 'tbes2004_web_rgto_crdl'
    bucket_name = os.environ['BUCKET_NAME']
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    indices = ["xes20042", "xes20043", "xes20044"]

    try:
        items = []
        for index in indices:
            response = dynamodb.query(TableName=table_name, IndexName=index)
            items.extend(response['Items'])

            last_evaluated_key = response.get('LastEvaluatedKey')
            while last_evaluated_key:
                response = dynamodb.query(TableName=table_name, IndexName=index, ExclusiveStartKey=last_evaluated_key)
                items.extend(response['Items'])
                last_evaluated_key = response.get('LastEvaluatedKey')

        df = pd.DataFrame(items)

        tmp_file_name = f'/tmp/{current_date}.parquet'
        df.to_parquet(tmp_file_name, compression='GZIP')

        s3.upload_file(tmp_file_name, bucket_name, f'{current_date}.parquet')

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
