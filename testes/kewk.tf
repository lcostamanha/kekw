import json
import traceback
import boto3

def lambda_handler(event, context):
    """
    Export Dynamodb to s3 (JSON)
    """

    statusCode = 200
    statusMessage = 'Success'

    try:
        # parse the payload
        tableName = event['tableName']
        s3_bucket = event['s3_bucket']
        s3_object = event['s3_object']
        filename = event['filename']

        # scan the dynamodb
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(tableName)

        response = table.scan()
        data = response['Items']

        # maximum data set limit is 1MB
        # so we need to have this additional step
        while 'LastEvaluatedKey' in response:
            response = dynamodb.scan(
                TableName=tableName,
                Select='ALL_ATTRIBUTES',
                ExclusiveStartKey=response['LastEvaluatedKey'])

            data.extend(response['Items'])
            
        # export JSON to s3 bucket
        s3 = boto3.resource('s3')
        s3.Object(s3_object, s3_object + filename).put(Body=json.dumps(data))

        except Exception as e:
            statusCode = 400
            statusMessage =  traceback.format_exc()

        return {
            "statusCode": statusCode,
            "status": statusMessage
        }














import boto3
import csv

# Crie um cliente para acessar o dynamodb
dynamodb = boto3.client('dynamodb')

# Defina o nome da tabela que você quer exportar
table_name = 'sua_tabela'

# Defina o nome do arquivo csv que você quer salvar no s3
csv_file_name = 'seu_arquivo.csv'

# Defina o nome do bucket s3 onde você quer salvar o arquivo csv
s3_bucket_name = 'seu_bucket'

# Crie um objeto para escrever no arquivo csv
csv_file = open(csv_file_name, 'w')
csv_writer = csv.writer(csv_file)

# Faça uma consulta no dynamodb para obter todos os itens da tabela
response = dynamodb.scan(TableName=table_name)

# Escreva os nomes das colunas no arquivo csv
columns = response['Items'][0].keys()
csv_writer.writerow(columns)

# Escreva os valores de cada item no arquivo csv
for item in response['Items']:
    values = [item[col]['S'] for col in columns]
    csv_writer.writerow(values)

# Feche o arquivo csv
csv_file.close()

# Crie um cliente para acessar o s3
s3 = boto3.client('s3')

# Faça o upload do arquivo csv para o bucket s3
s3.upload_file(csv_file_name, s3_bucket_name, csv_file_name)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

{
  "Records": [
    {
      "EventSource": "aws:s3",
      "EventVersion": "2.1",
      "S3": {
        "bucket": {
          "name": "seu_bucket"
        },
        "object": {
          "key": "seu_arquivo.csv"
        }
      }
    }
  ]
}

        
Esse evento simula a criação de um novo objeto no bucket seu_bucket com o nome seu_arquivo.csv. 
Quando esse evento é disparado, ele aciona a execução do lambda que lê a tabela sua_tabela do DynamoDB, 
escreve seus dados em um arquivo CSV e o carrega no bucket S3 seu_bucket com o nome seu_arquivo.csv.
            
        
        
        
        
        
        
        
        
  




import json
import traceback
import boto3

def lambda_handler(event, context):
    """
    Export Dynamodb to s3 (JSON)
    """

    statusCode = 200
    statusMessage = 'Success'

    try:
        # parse the payload
        tableName = event['tableName']
        s3_bucket = event['s3_bucket']
        s3_object = event['s3_object']
        filename = event['filename']

        # scan the dynamodb
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(tableName)

        response = table.scan()
        data = response['Items']

        # maximum data set limit is 1MB
        # so we need to have this additional step
        while 'LastEvaluatedKey' in response:
            response = dynamodb.scan(
                TableName=tableName,
                Select='ALL_ATTRIBUTES',
                ExclusiveStartKey=response['LastEvaluatedKey'])

            data.extend(response['Items'])
            
        # export JSON to s3 bucket
        s3 = boto3.resource('s3')
        s3.Object(s3_object, s3_object + filename).put(Body=json.dumps(data))

        except Exception as e:
            statusCode = 400
            statusMessage =  traceback.format_exc()

        return {
            "statusCode": statusCode,
            "status": statusMessage
        }
