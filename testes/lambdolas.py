import boto3
import datetime
import pandas as pd
import os

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

        # Verifica se há itens para salvar
        if items:
            # Transforma os itens em um formato adequado para o DataFrame
            transformed_items = [{key: list(value.values())[0] for key, value in item.items()} for item in items]

            # Cria o DataFrame a partir dos itens transformados
            df = pd.DataFrame(transformed_items)

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
