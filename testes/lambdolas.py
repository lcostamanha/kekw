import boto3
import datetime
import pandas as pd
import os

def extract_description(item):
    txt_objt_chav_pubi = item.get("txt_objt_chav_pubi", {})
    nom_idef_mtdo = txt_objt_chav_pubi.get("nom_idef_mtdo", {})
    device_properties = nom_idef_mtdo.get("device_properties", [])
    if device_properties and isinstance(device_properties, list):
        first_device_property = device_properties[0]
        item_description = first_device_property.get("item", {}).get("description", "")
        if not isinstance(item_description, dict):
            return item_description
    return ""

def transform_items(items):
    transformed_items = []
    for item in items:
        transformed_item = {}
        for key, value in item.items():
            if key == "txt_objt_chav_pubi":
                transformed_item[key] = extract_description(item)
            elif isinstance(value, dict):
                transformed_item[key] = flatten_value(value)
            else:
                transformed_item[key] = value
        transformed_items.append(transformed_item)
    return transformed_items

def flatten_value(value):
    if isinstance(value, dict):
        if len(value) == 1:
            v_key, v_value = list(value.items())[0]
            if v_key in ('S', 'B', 'N'):
                return v_value
        return {k: flatten_value(v) for k, v in value.items()}
    return value

def lambda_handler(event, context):
    # Configuração do cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    # Configuração do cliente do S3
    s3 = boto3.client('s3')

    # Nome da tabela do DynamoDB
    table_name = 'tbes2004_web_rgto_crdl'

    # Nome do bucket do S3
    bucket_name = os.environ['BUCKET_NAME']

    # Nome da pasta no bucket do S3
    folder_name = 'tb_fido'

    # Obtendo a data atual
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")

    try:
        # Obtendo todos os itens da tabela do DynamoDB
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']

        # Verifica se há mais páginas de resultados
        last_evaluated_key = response.get('LastEvaluatedKey')
        while last_evaluated_key:
            response = dynamodb.scan(TableName=table_name, ExclusiveStartKey=last_evaluated_key)
            items.extend(response['Items'])
            last_evaluated_key = response.get('LastEvaluatedKey')

        # Transforma os itens em um formato mais simples (sem a camada de chave-valor)
        transformed_items = transform_items(items)

        # Cria o DataFrame a partir dos itens transformados
        df = pd.DataFrame(transformed_items)

        # Modifica o campo "txt_objt_chav_pubi" para conter apenas o valor "description"
        df['txt_objt_chav_pubi'] = df['txt_objt_chav_pubi'].apply(lambda item: item.get('description', ''))

        # Salva o DataFrame em formato Parquet no diretório temporário
        tmp_file_name = f'/tmp/{current_date}.parquet'
        df.to_parquet(tmp_file_name, compression='GZIP')

        # Envia o arquivo para o S3 (na pasta tb_fido)
        s3.upload_file(tmp_file_name, bucket_name, f'{folder_name}/{current_date}.parquet')

        return {
            'statusCode': 200,
            'body': 'Dados salvos no S3 com sucesso.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao salvar os dados no S3: {str(e)}'
        }
