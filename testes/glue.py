import sys
import boto3
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import year, month, dayofmonth

class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.spark = self.glueContext.spark_session
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)
        self.s3_client = boto3.client("s3")

    def read_from_dynamo(self, table_name):
        return self.glueContext.create_dynamic_frame.from_options(
            "dynamodb",
            {"dynamodb.input.tableName": table_name,
             "dynamodb.throughput.read.percent": "1.0",
             "dynamodb.splits": "10"}
        )

    def write_to_s3(self, frame, s3_bucket):
        df = frame.toDF()
        df = df.withColumn("year", year(df["your_date_column"]))
        df = df.withColumn("month", month(df["your_date_column"]))
        df = df.withColumn("day", dayofmonth(df["your_date_column"]))

        path = f"s3://{s3_bucket}/glue/year={df['year']}/month={df['month']}/day={df['day']}/"
        df.write.parquet(path)

    def process(self, table_name, s3_bucket):
        frame = self.read_from_dynamo(table_name)
        self.write_to_s3(frame, s3_bucket)

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
