import boto3
import json
import datetime
import os
import pyarrow as pa
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
    current_date = datetime.datetime.now()
    year = current_date.strftime("%Y")
    month = current_date.strftime("%m")
    day = current_date.strftime("%d")
    
    try:
        # Criação da pasta tb_fido
        folder_name = 'tb_fido'
        s3.put_object(Body='', Bucket=bucket_name, Key=f'{folder_name}/')
        
        # Criação da pasta do ano, mês e dia
        year_folder = f'{folder_name}/{year}/'
        s3.put_object(Body='', Bucket=bucket_name, Key=year_folder)
        month_folder = f'{year_folder}{month}/'
        s3.put_object(Body='', Bucket=bucket_name, Key=month_folder)
        day_folder = f'{month_folder}{day}/'
        s3.put_object(Body='', Bucket=bucket_name, Key=day_folder)
        
        # Inicializa a chave de paginação
        last_evaluated_key = None
        
        # Lista para armazenar os dados particionados
        partitioned_data = {}
        
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
                # Obter os valores das colunas para particionar
                year_value = item['year']
                month_value = item['month']
                day_value = item['day']
                
                # Criação das chaves de partição
                partition_key = f'year={year_value}/month={month_value}/day={day_value}'
                
                # Adicionar o item aos dados particionados
                if partition_key not in partitioned_data:
                    partitioned_data[partition_key] = []
                
                partitioned_data[partition_key].append(item)
            
            # Sai do loop se não houver mais páginas
            if not last_evaluated_key:
                break
        
        # Loop para salvar cada partição em formato Parquet
        for partition_key, partition_data in partitioned_data.items():
            # Converte a lista de itens para uma tabela do PyArrow
            table = pa.Table.from_pandas(pd.DataFrame(partition_data))
            
            # Salva a tabela em formato Parquet no S3
            file_name = f'{folder_name}/{partition_key}/fido-export.parquet'
            pq.write_table(table, f's3://{bucket_name}/{file_name}')
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
