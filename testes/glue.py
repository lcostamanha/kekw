import sys
import boto3
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import date_format, current_date
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import DropNullFields


class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)

    def read_from_dynamo(self, table_name):
        return self.glueContext.create_dynamic_frame.from_catalog(
            database="your_database_name",
            table_name=table_name
        )

    def write_to_s3(self, frame, s3_path):
        self.glueContext.write_dynamic_frame.from_options(
            frame,
            connection_type="s3",
            format="parquet",
            connection_options={
                "path": s3_path,
                "partitionKeys": ["year", "month", "day"]
            }
        )

    def process(self, table_name, s3_path):
        dynamic_frame = self.read_from_dynamo(table_name)
        current_date_str = date_format(
            current_date(), 'yyyy-MM-dd').alias('current_date')
        df = dynamic_frame.toDF().withColumn(
            'current_date', current_date_str)
        df = df.withColumn('year', df['current_date'].substr(1, 4))
        df = df.withColumn('month', df['current_date'].substr(6, 2))
        df = df.withColumn('day', df['current_date'].substr(9, 2))
        dynamic_frame = DropNullFields.apply(
            self.glueContext.fromDF(df, dynamic_frame.schema))
        self.write_to_s3(dynamic_frame, s3_path)

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
