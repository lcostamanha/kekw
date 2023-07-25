import boto3
from collections import defaultdict
import pandas as pd

def flatten_value(value):
    if isinstance(value, dict):
        for k, v in value.items():
            if isinstance(v, dict) and len(v) == 1:
                v_key, v_value = list(v.items())[0]
                return {k: v_value}
            else:
                return {k: flatten_value(v)}
    return value

def save_to_parquet(data, bucket_name, file_name):
    # Cria o DataFrame a partir dos dados
    df = pd.DataFrame(data)

    # Salva o DataFrame em formato Parquet no S3
    s3 = boto3.client('s3')
    s3.put_object(Body=df.to_parquet(), Bucket=bucket_name, Key=file_name)

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    try:
        # Consulta todas as tabelas disponíveis no DynamoDB
        response = dynamodb.list_tables()
        tables = response['TableNames']

        # Dicionário para armazenar os resultados
        results = defaultdict(list)

        # Para cada tabela, consulta todos os itens
        for table_name in tables:
            response = dynamodb.scan(TableName=table_name)
            items = response['Items']

            # Verifica se há mais páginas de resultados
            last_evaluated_key = response.get('LastEvaluatedKey')
            while last_evaluated_key:
                response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
                items.extend(response['Items'])
                last_evaluated_key = response.get('LastEvaluatedKey')

            # Transforma os itens em uma estrutura mais plana
            transformed_items = [{key: flatten_value(value) for key, value in item.items()} for item in items]

            # Adiciona os itens transformados ao resultado final
            for item in transformed_items:
                for key, value in item.items():
                    results[key].append(value)

        # Salva os dados no formato Parquet no S3
        bucket_name = 'NOME_DO_BUCKET'  # Substitua pelo nome do seu bucket S3
        file_name = 'dados.parquet'  # Nome do arquivo no S3
        save_to_parquet(results, bucket_name, file_name)

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao consultar os dados no DynamoDB: {str(e)}'
        }
