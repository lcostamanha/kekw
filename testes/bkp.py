import sys
from datetime import datetime
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.job import Job

class GlueJob:
    def __init__(self, args):
        self.sc = SparkContext()
        self.glueContext = GlueContext(self.sc)
        self.job = Job(self.glueContext)
        self.job.init(args["JOB_NAME"], args)

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

    def process(self, table_name, s3_base_path):
        dynamo_frame = self.read_from_dynamo(table_name)
        current_date = datetime.now().strftime("%Y%m%d")
        s3_path = f"{s3_base_path}/anomesdia={current_date}/"
        self.write_to_s3(dynamo_frame, s3_path)

    def commit(self):
        self.job.commit()

def main():
    args = getResolvedOptions(sys.argv, ["JOB_NAME"])
    glue_job = GlueJob(args)
    table_name = "tbes2004_web_rgto_crdl"
    s3_path = "s3://itau-corp-sor-sa-east-1-428345910379/tb_fido"
    glue_job.process(table_name, s3_path)
    glue_job.commit()

if __name__ == "__main__":
    main()
