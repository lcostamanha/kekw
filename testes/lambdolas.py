import boto3
from collections import defaultdict

def flatten_value(value):
    if isinstance(value, dict):
        for k, v in value.items():
            if isinstance(v, dict) and len(v) == 1:
                v_key, v_value = list(v.items())[0]
                return {k: v_value}
            else:
                return {k: flatten_value(v)}
    return value

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    try:
        # Consulta todas as tabelas disponíveis no DynamoDB
        response = dynamodb.list_tables()
        tables = response['TableNames']

        # Dicionário para armazenar os resultados
        results = defaultdict(dict)

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

        return {
            'statusCode': 200,
            'body': results
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao consultar os dados no DynamoDB: {str(e)}'
        }
