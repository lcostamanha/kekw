import boto3
import json
import datetime
import os
import pandas as pd
import fastparquet

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    # Configuração do cliente do S3
    s3 = boto3.client('s3')

    # Nome da tabela do DynamoDB
    table_name = 'tbes2004_web_rgto_crdl'

    # Nome do bucket do S3
    bucket_name = os.environ['BUCKET_NAME']

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

        # Verifica se há itens para salvar
        if items:
            # Cria um DataFrame a partir dos itens
            df = pd.DataFrame(items)

            # Salva o DataFrame em formato Parquet
            folder_name = 'tb_fido'
            file_name = f'/tmp/{folder_name}/{current_date}-fido-export.parquet'
            os.makedirs(os.path.dirname(file_name), exist_ok=True)  # Cria o diretório se não existir
            fastparquet.write(file_name, df, compression='GZIP')

            # Envia o arquivo para o S3
            s3.upload_file(file_name, bucket_name, f'{folder_name}/{current_date}-fido-export.parquet')

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }