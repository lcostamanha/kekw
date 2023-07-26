import json
import pandas as pd
import boto3

def lambda_handler(event, context):
    # Nome da tabela do DynamoDB
    table_name = 'nome_da_sua_tabela'

    # Inicializar o cliente do DynamoDB
    dynamodb_client = boto3.client('dynamodb')

    # Realizar a leitura dos dados do DynamoDB
    response = dynamodb_client.scan(TableName=table_name)

    # Extrair os itens do resultado da leitura
    items = response['Items']

    # Converter os itens do DynamoDB em objetos Python
    data = [json.loads(item) for item in items]

    # Lista para armazenar os resultados processados
    processed_results = []

    # Iterar sobre cada entrada no JSON e extrair as chaves desejadas
    for entry in data:
        processed_entry = {
            "cod_idef_pess": entry["cod_idef_pess"]["S"],
            "num_cnta_entr": entry["num_cnta_entr"]["S"],
            "cod_usua_cada_crdl": entry["cod_usua_cada_crdl"]["S"],
            "cod_idef_usua": entry["txt_objt_usua"]["M"]["cod_idef_usua"]["S"],
            "nom_exib_usua": entry["txt_objt_usua"]["M"]["nom_exib_usua"]["S"],
            "nom_usua": entry["txt_objt_usua"]["M"]["nom_usua"]["S"]
        }
        # Adicione mais chaves conforme necessário

        # Adicionar o resultado processado à lista
        processed_results.append(processed_entry)

    # Criar um DataFrame pandas com os resultados processados
    df = pd.DataFrame(processed_results)

    # Especificar o caminho do arquivo parquet
    parquet_file_path = "/tmp/results.parquet"

    # Salvar o DataFrame em formato parquet
    df.to_parquet(parquet_file_path, index=False)

    # Ler o arquivo parquet em formato bytes
    with open(parquet_file_path, "rb") as f:
        parquet_data = f.read()

    # Retornar o arquivo parquet em formato bytes
    return {
        "statusCode": 200,
        "body": parquet_data,
        "headers": {
            "Content-Type": "application/octet-stream",
            "Content-Disposition": "attachment; filename=results.parquet"
        }
    }
