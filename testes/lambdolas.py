import json
import pandas as pd

def lambda_handler(event, context):
    # Extrair o conteúdo do arquivo JSON do evento recebido
    json_content = event['json_file_content']

    # Converter o JSON em um objeto Python
    data = json.loads(json_content)

    # Lista para armazenar os resultados processados
    processed_results = []

    # Iterar sobre cada entrada no JSON e extrair as chaves desejadas
    for entry in data:
        processed_entry = {
            "cod_idef_pess": entry["cod_idef_pess"],
            "num_cnta_entr": entry["num_cnta_entr"],
            "cod_usua_cada_crdl": entry["cod_usua_cada_crdl"],
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

    # Salvar o DataFrame em formato parquet sem o pyarrow
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
