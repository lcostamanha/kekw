import sys
from awsglue.utils import getResolvedOptions
from awsglue.dynamicframe import DynamicFrame
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import boto3
from datetime import datetime
class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.spark = self.glueContext.spark_session
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)
        self.s3_client = boto3.client("s3")
    def add_partition_cols(self, dynamic_frame):
        current_date = datetime.now()
        return dynamic_frame.withColumn("year", current_date.year)\
                            .withColumn("month", current_date.month)\
                            .withColumn("day", current_date.day)
    def read_from_dynamo(self, table_name):
        return self.glueContext.create_dynamic_frame.from_options(
            connection_type="dynamodb",
            connection_options={
                "dynamodb.input.tableName": table_name,
                "dynamodb.throughput.read.percent": "1.0",
                "dynamodb.splits": "1",
            }
        )
    def write_to_s3(self, frame, s3_path):
        self.glueContext.write_dynamic_frame.from_options(
            frame=frame,
            connection_type="s3",
            format="parquet",
            connection_options={
                "path": s3_path,
                "partitionKeys": ["year", "month", "day"]
            }
        )
    def process(self, table_name, s3_path):
        df_items = self.read_from_dynamo(table_name)
        df_items = self.add_partition_cols(df_items)
        self.write_to_s3(df_items, s3_path)
    def commit(self):
        self.job.commit()
def main():
    args = getResolvedOptions(sys.argv, ["JOB_NAME"])
    glue_job = GlueJob(args)
    table_name = "tbes2004_web_rgto_crdl"
    s3_path = "s3://itau-corp-sor-sa-east-1-428345910379/glue/"
    glue_job.process(table_name, s3_path)
    glue_job.commit()
if __name__ == "__main__":
    main()
