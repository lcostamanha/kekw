import boto3
import datetime
import pandas as pd
import os

def flatten_value(value):
    if isinstance(value, dict):
        # Ignora completamente o campo txt_objt_usua
        if 'txt_objt_usua' in value:
            del value['txt_objt_usua']

        # Se o campo txt_objt_chav_pubi existir, tenta extrair o campo description
        if 'txt_objt_chav_pubi' in value and isinstance(value['txt_objt_chav_pubi'], dict):
            description_value = value['txt_objt_chav_pubi']
            for key in ['M', 'nom_idef_mtdo', 'device_properties']:
                if key in description_value:
                    description_value = description_value[key]
                else:
                    description_value = None
                    break

            if description_value is not None and isinstance(description_value, list):
                for item in description_value:
                    if isinstance(item, dict) and 'description' in item:
                        value['txt_objt_chav_pubi'] = item['description']
                        break
                else:
                    value['txt_objt_chav_pubi'] = ''

        if len(value) == 1:
            v_key, v_value = list(value.items())[0]
            if v_key in ('S', 'B', 'N'):
                return v_value
            elif v_key == 'M':
                return flatten_value(v_value)
        return {k: flatten_value(v) for k, v in value.items() if k != 'L'}  # Ignora os campos que são 'L'
    elif isinstance(value, list):
        return [flatten_value(v) for v in value]
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
        transformed_items = [flatten_value(item) for item in items]

        # Cria o DataFrame a partir dos itens transformados
        df = pd.DataFrame(transformed_items)

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
