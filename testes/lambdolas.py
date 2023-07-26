import boto3
import datetime
import pandas as pd
import os

def flatten_value(value):
    if isinstance(value, dict):
        for k, v in value.items():
            if isinstance(v, dict) and len(v) == 1:
                v_key, v_value = list(v.items())[0]
                if v_key in ('S', 'B', 'N'):
                    return {k: v_value}
                else:
                    return {k: flatten_value(v)}  # Lidar com o caso de camada interna de chave-valor
            else:
                return {k: flatten_value(v)}
    return value

def transform_items(items):
    transformed_items = []
    for item in items:
        transformed_item = {key: flatten_value(value) for key, value in item.items()}
        transformed_item = {k: v for key, value in transformed_item.items() for k, v in value.items()}
        transformed_items.append(transformed_item)
    return transformed_items

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    # Configuração do cliente do S3
    s3 = boto3.client('s3')

    # Nome da tabela do DynamoDB
    table_name = 'tbes2004_web_rgto_crdl'

    # Nome do bucket do S3
    bucket_name = os.environ['BUCKET_NAME']

    # Nome da pasta no bucket do S3
    folder_name = 'tb_fido'

    # Obtendo a data atual
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")

    try:
        # Obtendo todos os itens da tabela do DynamoDB
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']

        # Verifica se há mais páginas de resultados
        last_evaluated_key = response.get('LastEvaluatedKey')
        while last_evaluated_key:
            response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
            items.extend(response['Items'])
            last_evaluated_key = response.get('LastEvaluatedKey')

        # Transforma os itens em um formato mais simples (sem a camada de chave-valor)
        for item in items:
            for key, value in item.items():
                if isinstance(value, dict) and len(value) == 1:
                    item[key] = list(value.values())[0]
                else:
                    item[key] = flatten_value(value)  # Lidar com o caso de camada interna de chave-valor

        # Cria o DataFrame a partir dos itens transformados
        df = pd.DataFrame(items)

        # Salva o DataFrame em formato Parquet no diretório temporário
        tmp_file_name = f'/tmp/{current_date}.parquet'
        df.to_parquet(tmp_file_name, compression='GZIP')

        # Envia o arquivo para o S3 (na pasta tb_fido)
        s3.upload_file(tmp_file_name, bucket_name, f'{folder_name}/{current_date}.parquet')

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
