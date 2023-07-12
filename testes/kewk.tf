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
        # Inicializa a chave de paginação
        last_evaluated_key = None
        
        # Tamanho máximo do arquivo em bytes (260 MB)
        max_file_size = 260 * 1024 * 1024
        
        # Contador para controlar o tamanho atual do arquivo
        current_file_size = 0
        
        # Contador para controlar o número de arquivos criados
        file_counter = 1
        
        # Criação do arquivo inicial
        file_name = f'{current_date}/fido-export-{file_counter}.json'
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
                # Converte o item em uma string JSON
                item_json = json.dumps(item)
                
                # Calcula o tamanho do item em bytes
                item_size = len(item_json.encode('utf-8'))
                
                # Verifica se o item cabe no arquivo atual
                if current_file_size + item_size > max_file_size:
                    # Salva o arquivo atual no S3
                    s3.put_object(Body=json.dumps(file_contents), Bucket=bucket_name, Key=file_name)
                    
                    # Incrementa o contador e cria um novo arquivo
                    file_counter += 1
                    file_name = f'{current_date}/fido-export-{file_counter}.json'
                    file_contents = []
                    current_file_size = 0
                
                # Adiciona o item ao arquivo atual
                file_contents.append(item)
                current_file_size += item_size
            
            # Sai do loop se não houver mais páginas
            if not last_evaluated_key:
                break
        
        # Salva o último arquivo no S3
        s3.put_object(Body=json.dumps(file_contents), Bucket=bucket_name, Key=file_name)
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
