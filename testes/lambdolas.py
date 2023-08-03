import sys
import boto3
from awsglue.transforms import ApplyMapping
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

bucket_name = 'extraction-fido-dev'
table_name = 'tbes2004_web_rgto_crdl'

# Use the DynamoDB connector for Apache Spark
dynamodb = boto3.resource('dynamodb', region_name='sa-east-1') 
table = dynamodb.Table(table_name)
items = table.scan()['Items']

# Convert the items to a DataFrame
df = spark.createDataFrame(items)

# Print the schema of the DataFrame
df.printSchema()

# Apply the necessary transformations
# Change this mappings to fit your table schema
df_transformed = ApplyMapping.apply(
    frame = df,
    mappings = [
        ("cod_perf_aces", "int", "cod_perf_aces", "int"),
        ("nom_perf_aces", "string", "nom_perf_aces", "string"),
        ("des_perf_aces", "string", "des_perf_aces", "string")
    ]
)

# Print the schema of the transformed DataFrame
df_transformed.printSchema()

# Write the DataFrame to S3 as a parquet file
df_transformed.write.parquet(f"s3://{bucket_name}/data/output/")

job.commit()
