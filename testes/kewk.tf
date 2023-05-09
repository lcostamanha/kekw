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







