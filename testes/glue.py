import sys
from datetime import datetime
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.job import Job
import boto3


class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)
        self.glue_client = boto3.client('glue')

    def read_from_dynamo(self, table_name):
        return self.glueContext.create_dynamic_frame.from_options(
            connection_type="dynamodb",
            connection_options={
                "dynamodb.input.tableName": table_name,
                "dynamodb.throughput.read.percent": "1.0",
                "dynamodb.splits": "1"
            }
        )

    def write_to_s3(self, dynamic_frame, s3_path):
        self.glueContext.write_dynamic_frame.from_options(
            frame=dynamic_frame,
            connection_type="s3",
            format="parquet",
            connection_options={"path": s3_path}
        )

    def create_partition(self, database_name, table_name, s3_path,
                         partition_value, table_data):
        try:
            self.glue_client.create_partition(
                DatabaseName=database_name,
                TableName=table_name,
                CatalogId="773683090477",
                PartitionInput={
                    "Values": [partition_value],
                    "StorageDescriptor": {
                        "Location": s3_path,
                        "InputFormat": table_data["input_format"],
                        "OutputFormat": table_data["output_format"],
                        "SerdeInfo": table_data["serde_info"]
                    }
                }
            )
        except Exception as e:
            print("Error create_partition", e)

    def get_table_schema(self, CatalogId, database_name, table_name):
        try:
            response = self.glue_client.get_table(
                CatalogId=CatalogId,
                DatabaseName=database_name,
                Name=table_name
            )
            print(f"Exception while fetching table info: {error}")
            print("Exception while fetching table info")
            sys.exit(-1)

        table_data = {}
        table_data['input_format'] = \
            response['Table']['StorageDescriptor']['InputFormat']
        table_data['output_format'] = \
            response['Table']['StorageDescriptor']['OutputFormat']
        table_data['table_location'] = \
            response['Table']['StorageDescriptor']['Location']
        table_data['serde_info'] = \
            response['Table']['StorageDescriptor']['SerdeInfo']
        table_data['partition_keys'] = response['Table']['PartitionKeys']

        return table_data

    def process(self, table_name, s3_base_path, database_name,
                glue_table_name, CatalogId):
        dynamo_frame = self.read_from_dynamo(table_name)
        current_date = datetime.now().strftime("%Y%m%d")
        s3_path = f"{s3_base_path}/anomesdia={current_date}/"
        table_data = self.get_table_schema(CatalogId, database_name,
                                           glue_table_name)
        self.write_to_s3(dynamo_frame, s3_path)
        self.create_partition(database_name, glue_table_name, s3_path,
                              current_date, table_data)

    def commit(self):
        self.job.commit()


def main():
    args = getResolvedOptions(sys.argv, ["JOB_NAME", "CatalogIdControl",
                                         "BKT_DEST"])
    CatalogId = args["CatalogIdControl"]
    bkt_dest = args["BKT_DEST"]
    s3_path = f"s3://{bkt_dest}/tb_fido"
    glue_job = GlueJob(args)
    table_name = "tbes2004_web_rgto_crdl"
    database_name ="db_source_identificacaoeautenticacaodeclientes_customeriam_sor_01"    glue_table_name = "tb_fido"
    glue_job.process(table_name, s3_path, database_name, glue_table_name,
                     CatalogId)
    glue_job.commit()


if __name__ == "__main__":
    main()
