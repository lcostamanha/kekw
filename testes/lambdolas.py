import boto3
import datetime
import pandas as pd
import os

def flatten_value(value):
    if isinstance(value, dict):
        if len(value) == 1:
            v_key, v_value = list(value.items())[0]
            if v_key in ('S', 'B', 'N'):
                return v_value
        return {k: flatten_value(v) for k, v in value.items()}
    return value

def transform_items(items):
    transformed_items = []
    for item in items:
        transformed_item = {}
        for key, value in item.items():
            if isinstance(value, dict):
                transformed_item[key] = flatten_value(value)
            else:
                transformed_item[key] = value
        transformed_items.append(transformed_item)
    return transformed_items

def get_description(item):
    if "txt_objt_chav_pubi" in item:
        txt_objt_chav_pubi = item["txt_objt_chav_pubi"]
        if "txt_objt_idef_chav" in txt_objt_chav_pubi:
            txt_objt_idef_chav = txt_objt_chav_pubi["txt_objt_idef_chav"]
            if "txt_trsp" in txt_objt_idef_chav:
                txt_trsp = txt_objt_idef_chav["txt_trsp"]
                if txt_trsp:
                    return txt_trsp[0]["item"]
    return None

def lambda_handler(event, context):
    # Restante do código igual ao lambda anterior...

    # Cria o DataFrame a partir dos itens transformados
    df = pd.DataFrame(transformed_items)

    # Adiciona a coluna "txt_objt_chav_pubi_description" com o valor desejado
    df["txt_objt_chav_pubi_description"] = df.apply(get_description, axis=1)

    # Salva o DataFrame em formato Parquet no diretório temporário
    tmp_file_name = f'/tmp/{current_date}.parquet'
    df.to_parquet(tmp_file_name, compression='GZIP')

    # Restante do código igual ao lambda anterior...
