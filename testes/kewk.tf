import boto3
import json
import datetime
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

    # Obtendo a data atual
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")

    try:
        # Lista para armazenar todos os itens
        all_items = []

        # Inicializa a chave de paginação
        last_evaluated_key = None

        # Loop para obter todas as páginas de resultados
        while True:
            # Configuração da paginação com a chave de paginação
            if last_evaluated_key:
                response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
            else:
                response = dynamodb.scan(TableName=table_name)

            # Adiciona os itens à lista
            items = response['Items']
            all_items.extend(items)

            # Verifica se há mais páginas de resultados
            last_evaluated_key = response.get('LastEvaluatedKey')

            # Sai do loop se não houver mais páginas
            if not last_evaluated_key:
                break

        # Convertendo os itens para um formato JSON
        json_data = json.dumps(all_items)

        # Salvando os dados no S3 com um prefixo de data
        s3.put_object(Body=json_data, Bucket=bucket_name, Key=f'{current_date}/fido-export.json')

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
