import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Define your DynamoDB table name
table_name = "tbes2004_web_rgto_crdl"
# Define your output path
output_path = "s3://extraction-fido-dev/glue/"

# Reading data from DynamoDB
dynamodb_df = glueContext.create_dynamic_frame.from_options(
    connection_type="dynamodb",
    connection_options={
        "dynamodb.input.tableName": table_name,
        "dynamodb.throughput.read.percent": "1.0"
    }
)

# Write the data to S3 in parquet format
glueContext.write_dynamic_frame.from_options(
    frame=dynamodb_df,
    connection_type="s3",
    connection_options={"path": output_path},
    format="parquet"
)

job.commit()
