import boto3
import json
import datetime
import os
import pandas as pd
import pyarrow.parquet as pq

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
        # Inicializa a chave de paginação
        last_evaluated_key = None
        
        # Lista para armazenar os dados
        data = []
        
        # Loop para obter todas as páginas de resultados
        while True:
            # Configuração da paginação com a chave de paginação
            if last_evaluated_key:
                response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
            else:
                response = dynamodb.scan(TableName=table_name)
            
            # Adiciona os itens à lista
            items = response['Items']
            
            # Verifica se há mais páginas de resultados
            last_evaluated_key = response.get('LastEvaluatedKey')
            
            # Loop para processar cada item
            for item in items:
                data.append(item)
            
            # Sai do loop se não houver mais páginas
            if not last_evaluated_key:
                break
        
        # Converte a lista de itens em um DataFrame do pandas
        df = pd.DataFrame(data)
        
        # Salva o DataFrame em formato Parquet no S3
        file_name = f'tb_fido/fido-export-{current_date}.parquet'
        pq.write_table(pa.Table.from_pandas(df), f's3://{bucket_name}/{file_name}')
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
