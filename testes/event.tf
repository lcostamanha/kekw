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
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")

    try:
        # Inicializa a chave de paginação
        last_evaluated_key = None

        # Tamanho máximo do arquivo em bytes (500 MB)
        max_file_size = 500 * 1024 * 1024

        # Contador para controlar o tamanho atual do arquivo
        current_file_size = 0

        # Contador para controlar o número de arquivos criados
        file_counter = 1

        # Criação do arquivo inicial
        file_name = f'{current_date}/fido-export-{file_counter}.parquet'
        file_contents = []

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
                # Adiciona o item à lista do arquivo atual
                file_contents.append(item)

            # Calcula o tamanho do arquivo em bytes
            file_size = len(json.dumps(file_contents).encode('utf-8'))

            # Verifica se o arquivo atual excede o tamanho máximo
            if file_size > max_file_size:
                # Salva o arquivo atual em formato Parquet
                table = pa.Table.from_pandas(pd.DataFrame(file_contents))
                with pa.OSFile(f'/tmp/{file_name}', 'wb') as f:
                    pq.write_table(table, f)
                s3.upload_file(f'/tmp/{file_name}', bucket_name, file_name)

                # Incrementa o contador e cria um novo arquivo
                file_counter += 1
                file_name = f'{current_date}/fido-export-{file_counter}.parquet'
                file_contents = []

        # Salva o último arquivo em formato Parquet
        if file_contents:
            table = pa.Table.from_pandas(pd.DataFrame(file_contents))
            with pa.OSFile(f'/tmp/{file_name}', 'wb') as f:
                pq.write_table(table, f)
            s3.upload_file(f'/tmp/{file_name}', bucket_name, file_name)

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
