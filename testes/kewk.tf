import boto3
import json

def lambda_handler(event, context):
    # Configurar o cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')
    
    # Configurar o cliente do S3
    s3 = boto3.client('s3')
    
    # Nome da tabela do DynamoDB
    table_name = 'NomeDaTabela'
    
    try:
        # Obter todos os itens da tabela do DynamoDB
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']
        
        # Converter os itens para o formato JSON
        json_data = json.dumps(items)
        
        # Nome do bucket do S3
        bucket_name = 'NomeDoBucket'
        
        # Nome do arquivo a ser salvo no S3
        file_name = 'dados.json'
        
        # Gravar os dados no S3
        s3.put_object(Body=json_data, Bucket=bucket_name, Key=file_name)
        
        return {
            'statusCode': 200,
            'body': 'Dados salvos com sucesso no S3.'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }

    
    
    
   {
  "key": "value"
}

    
    
    
    
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DynamoDBAccess",
            "Effect": "Allow",
            "Action": [
                "dynamodb:Scan"
            ],
            "Resource": [
                "arn:aws:dynamodb:região:ID-da-conta:dynamodb:Tabela"
            ]
        },
        {
            "Sid": "S3Access",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::NomeDoBucket/*"
            ]
        }
    ]
}
    
    
    
    
    
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::ID-da-conta-do-Lambda:role/NomeDaFuncaoDoLambda"
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::NomeDoBucket/*"
            ]
        }
    ]
}


