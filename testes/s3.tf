import boto3
import csv
import io

def lambda_handler(event, context):
    # Nome da tabela do DynamoDB
    dynamodb_table_name = 'NomeDaTabela'

    # Nome do bucket do S3 para salvar o arquivo CSV
    s3_bucket_name = 'NomeDoBucket'

    # Nome do arquivo CSV a ser gerado
    csv_file_name = 'dados.csv'

    # Inicializa o cliente do DynamoDB
    dynamodb = boto3.client('dynamodb')

    # Realiza uma scan na tabela para obter todos os itens
    response = dynamodb.scan(TableName=dynamodb_table_name)

    # Obtém os itens retornados
    items = response['Items']

    # Caso a tabela possua mais itens, é necessário realizar paginacao
    while 'LastEvaluatedKey' in response:
        response = dynamodb.scan(TableName=dynamodb_table_name,
                                 ExclusiveStartKey=response['LastEvaluatedKey'])
        items.extend(response['Items'])

    # Verifica se a tabela possui itens
    if not items:
        print("A tabela está vazia.")
        return

    # Gera o arquivo CSV em memória
    csv_buffer = io.StringIO()
    csv_writer = csv.writer(csv_buffer)

    # Escreve os cabeçalhos das colunas
    csv_writer.writerow(items[0].keys())

    # Escreve os dados dos itens no arquivo CSV
    for item in items:
        csv_writer.writerow(item.values())

    # Inicializa o cliente do S3
    s3 = boto3.client('s3')

    # Define o nome do arquivo no S3
    s3_object_key = csv_file_name

    # Salva o arquivo CSV no S3
    s3.put_object(Body=csv_buffer.getvalue(),
                  Bucket=s3_bucket_name,
                  Key=s3_object_key)

    print(f"O arquivo CSV '{csv_file_name}' foi salvo no bucket '{s3_bucket_name}' com sucesso.")

      
      
      
      
      
Certifique-se de substituir 'NomeDaTabela' pelo nome da sua tabela no DynamoDB, 'NomeDoBucket' pelo nome do seu bucket no S3 e 'dados.csv' pelo nome desejado para o arquivo CSV.

Além disso, lembre-se de configurar as permissões corretas para o Lambda acessar o DynamoDB e o S3. Você pode criar uma função do Lambda com as seguintes permissões:

DynamoDB: dynamodb:Scan (para ler dados da tabela)
S3: s3:PutObject (para salvar o arquivo CSV no S3)
Após criar a função Lambda e configurar as permissões, você pode invocá-la para gerar o arquivo CSV no S3 com os dados da tabela do DynamoDB.
        
      
      
      
      
      
      
      
      {
  "key1": "value1",
  "key2": "value2"
}
