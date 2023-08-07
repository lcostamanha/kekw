import sys
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Reading data from DynamoDB
ddb_frame = glueContext.create_dynamic_frame.from_options(
    connection_type="dynamodb",
    connection_options={
        "dynamodb.input.tableName": "tbes2004_web_rgto_crdl",
        "dynamodb.throughput.read.percent": "0.5",
        "dynamodb.splits": "100",
    }
)

# Writing data to S3
glueContext.write_dynamic_frame.from_options(
    frame=ddb_frame,
    connection_type="s3",
    connection_options={"path": "s3://itau-corp-sor-sa-east-1-428345910379/glue/"},
    format="parquet",
)

job.commit()
