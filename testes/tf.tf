import pyarrow as pa
import pyarrow.parquet as pq
import json

def save_parquet_to_s3(data, s3_client, bucket, key):
    table = pa.Table.from_pandas(pd.DataFrame(data))
    with pa.OSFile(f'/tmp/{key}', 'wb') as f:
        pq.write_table(table, f)
    s3_client.upload_file(f'/tmp/{key}', bucket, key)
