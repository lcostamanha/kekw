import boto3
import json
import datetime

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')
    
    # Configuração do cliente do S3
    s3 = boto3.client('s3')
    
    # Nome da tabela do DynamoDB
    table_name = 'NomeDaTabela'
    
    # Nome do bucket do S3
    bucket_name = 'NomeDoBucket'
    
    # Obtendo a data atual
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    
    try:
        # Obtendo os dados da tabela do DynamoDB
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']
        
        # Convertendo os itens para um formato JSON
        json_data = json.dumps(items)
        
        # Salvando os dados no S3 com um prefixo de data
        s3.put_object(Body=json_data, Bucket=bucket_name, Key=f'{current_date}/dados.json')
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
