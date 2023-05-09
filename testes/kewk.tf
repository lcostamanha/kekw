import json
import boto3
import datetime

def lambda_handler(event, context):
    # Define o nome da tabela do DynamoDB
    table_name = 'nome_da_tabela'
    
    # Define o nome do bucket S3
    s3_bucket_name = 'nome_do_bucket_s3'
    
    # Define o nome do arquivo que será salvo no bucket S3
    s3_key = 'pasta/nome_do_arquivo.json'
    
    # Cria uma conexão com o DynamoDB
    dynamodb = boto3.resource('dynamodb')
    
    # Obtém a tabela do DynamoDB
    table = dynamodb.Table(table_name)
    
    # Obtém todos os itens da tabela
    response = table.scan()
    
    # Salva os itens no arquivo JSON
    items = response['Items']
    while 'LastEvaluatedKey' in response:
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        items.extend(response['Items'])
        
    # Converte os itens para JSON
    items_json = json.dumps(items, default=str)
    
    # Salva o arquivo JSON no bucket S3
    s3 = boto3.resource('s3')
    s3_object = s3.Object(s3_bucket_name, s3_key)
    s3_object.put(Body=items_json)
    
    # Retorna a mensagem de sucesso
    return {
        'statusCode': 200,
        'body': 'Exportação para o S3 realizada com sucesso!'
    }

        
        
        
        
        
Lembre-se de configurar as permissões necessárias no IAM Role do Lambda para acessar a tabela 
do DynamoDB e o bucket do S3. Além disso, 
substitua os valores 
nome_da_tabela, 
nome_do_bucket_s3, 
pasta/nome_do_arquivo.json pelos valores correspondentes da sua aplicação.
