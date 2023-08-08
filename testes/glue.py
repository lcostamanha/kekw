import sys
import boto3
from pyspark.context import SparkContext
from pyspark.sql.functions import current_date, date_format
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions


class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.spark = self.glueContext.spark_session
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)
        self.s3_client = boto3.client("s3")

    def read_from_dynamo(self, table_name):
        return self.glueContext.create_dynamic_frame.from_catalog(
            database="your-database-name",
            table_name=table_name
        )

    def write_to_s3(self, dynamic_frame, s3_bucket):
        current_date_str = date_format(
            current_date(), 'yyyy-MM-dd').alias('current_date')
        df = dynamic_frame.toDF().withColumn(
            'current_date', current_date_str)
        df = df.withColumn('year', df.current_date.substr(1, 4))
        df = df.withColumn('month', df.current_date.substr(6, 2))
        df = df.withColumn('day', df.current_date.substr(9, 2))
        s3_path = (f"s3://{s3_bucket}/data/"
                   f"year={df.year}/month={df.month}/day={df.day}/")
        df_partitioned = DynamicFrame.fromDF(
            df, self.glueContext, "df_partitioned")
        self.glueContext.write_dynamic_frame.from_options(
            frame=df_partitioned,
            connection_type="s3",
            format="parquet",
            connection_options={
                "path": s3_path, "partitionKeys": ["year", "month", "day"]
            }
        )

    def process(self, table_name, s3_bucket):
        dynamic_frame = self.read_from_dynamo(table_name)
        self.write_to_s3(dynamic_frame, s3_bucket)

    def commit(self):
        self.job.commit()


def main():
    args = getResolvedOptions(sys.argv, ["JOB_NAME"])
    glue_job = GlueJob(args)
    table_name = "tbes2004_web_rgto_crdl"
    s3_bucket = "itau-corp-sor-sa-east-1-428345910379"
    glue_job.process(table_name, s3_bucket)
    glue_job.commit()


if __name__ == "__main__":
    main()
