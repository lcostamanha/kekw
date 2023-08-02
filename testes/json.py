import boto3
import json

dynamodb = boto3.resource('dynamodb')
table_name = 'tbes2004_web_rgto_crdl'
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        # Ler o arquivo JSON com os dados
        with open('data.json') as f:
            data = json.load(f)

        # Inserir cada item do JSON na tabela do DynamoDB
        for item in data:
            table.put_item(Item=item)

        return {
            'statusCode': 200,
            'body': 'Dados inseridos com sucesso!'
        }

    except Exception as e:
        print('Erro:', e)
        return {
            'statusCode': 500,
            'body': 'Ocorreu um erro ao executar o Lambda.'
        }
