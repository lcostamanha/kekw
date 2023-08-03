import sys
import datetime
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext

ARG_TABLE_NAME = "table_name"
ARG_READ_PERCENT = "read_percentage"
ARG_OUTPUT = "output_prefix"
ARG_FORMAT = "output_format"

PARTITION = "snapshot_timestamp"

args = getResolvedOptions(sys.argv,
  [
    'JOB_NAME',
    ARG_TABLE_NAME,
    ARG_READ_PERCENT,
    ARG_OUTPUT,
    ARG_FORMAT
  ]
)

table_name = args[ARG_TABLE_NAME]
read = args[ARG_READ_PERCENT]
output_prefix = args[ARG_OUTPUT]
fmt = args[ARG_FORMAT]

print("Table name:", table_name)
print("Read percentage:", read)
print("Output prefix:", output_prefix)
print("Format:", fmt)

date_str = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M')
output = "%s/%s=%s" % (output_prefix, PARTITION, date_str)

sc = SparkContext()
glueContext = GlueContext(sc)

table = glueContext.create_dynamic_frame.from_options(
  "dynamodb",
  connection_options={
    "dynamodb.input.tableName": "tbes2004_web_rgto_crdl",  # Your DynamoDB Table Name
    "dynamodb.throughput.read.percent": "0.5"  # Read capacity percentage
  }
)

glueContext.write_dynamic_frame.from_options(
  frame=table,
  connection_type="s3",
  connection_options={
    "path": "s3://extraction-fido-dev/"  # Your S3 Bucket Name
  },
  format="parquet",
  transformation_ctx="datasink"
)
