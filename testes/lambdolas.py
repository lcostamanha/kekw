import boto3
import datetime
import pandas as pd
import os
import json
from multiprocessing.pool import ThreadPool

def flatten_value(value):
    if isinstance(value, dict):
        if 'txt_objt_usua' in value:
            del value['txt_objt_usua']

        if 'txt_objt_chav_pubi' in value:
            value['txt_objt_chav_pubi'] = get_description(value['txt_objt_chav_pubi'])

        if len(value) == 1:
            v_key, v_value = list(value.items())[0]
            if v_key in ('S', 'B', 'N'):
                return v_value
            elif v_key == 'M':
                return flatten_value(v_value)
        return {k: flatten_value(v) for k, v in value.items() if k != 'L'}
    elif isinstance(value, list):
        return [flatten_value(v) for v in value]
    return value

def get_description(obj):
    try:
        return obj['M']['nom_idef_mtdo']['M']['device_properties']['L'][0]['M']['description']['S']
    except (KeyError, IndexError, TypeError):
        return ''

def process_data(items):
    transformed_items = [flatten_value(item) for item in items]
    df = pd.DataFrame(transformed_items)
    tmp_file_name = f'/tmp/{current_date}.parquet'
    df.to_parquet(tmp_file_name, compression='GZIP')
    s3.upload_file(tmp_file_name, bucket_name, f'{current_date}.parquet')
    
def lambda_handler(event, context):
    dynamodb = boto3.client('dynamodb')
    s3 = boto3.client('s3')
    table_name = 'tbes2004_web_rgto_crdl'
    bucket_name = os.environ['BUCKET_NAME']
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    pool = ThreadPool(processes=2)  # Ajustado para 2, de acordo com o número de vCPUs disponíveis
    
    try:
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']
        
        pool.apply_async(process_data, (items,))
        
        last_evaluated_key = response.get('LastEvaluatedKey')
        while last_evaluated_key:
            response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
            items = response['Items']
            pool.apply_async(process_data, (items,))
            last_evaluated_key = response.get('LastEvaluatedKey')

        pool.close()
        pool.join()
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
