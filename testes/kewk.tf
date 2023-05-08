resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_configuration = aws_launch_configuration.example.id
  min_size             = 1
  max_size             = 3

  # Use spot instances for the workers
  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy = "prioritized"
      on_demand_base_capacity       = 0
      spot_allocation_strategy      = "capacity-optimized"
    }

    launch_template {
      id      = aws_launch_template.example.id
      version = "$Latest"
    }
  }

  # Use a warm pool for the workers
  warm_pool {
    min_size     = 1
    max_size     = 2
    pool_state   = "stopped"
    purge_policy = "OldestInstance"
  }
}


############################################################################################################
# Importar os módulos necessários
import unittest
import boto3
import json
from moto import mock_dynamodb2, mock_s3
from lambda_function import lambda_handler

# Definir uma classe que herda de unittest.TestCase
class TestLambda(unittest.TestCase):

    # Definir um método setUp que é executado antes de cada teste
    def setUp(self):
        # Criar um mock do DynamoDB e do S3
        self.mock_dynamodb = mock_dynamodb2()
        self.mock_s3 = mock_s3()
        self.mock_dynamodb.start()
        self.mock_s3.start()

        # Criar uma tabela no DynamoDB com os mesmos atributos da tabela real
        self.dynamodb = boto3.resource('dynamodb')
        self.table = self.dynamodb.create_table(
            TableName='tbes2004_web_rgto_crdl',
            KeySchema=[
                {
                    'AttributeName': 'id',
                    'KeyType': 'HASH'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'id',
                    'AttributeType': 'S'
                }
            ]
        )

        # Inserir alguns dados na tabela
        self.table.put_item(Item={'id': '1', 'nome': 'João', 'idade': 25})
        self.table.put_item(Item={'id': '2', 'nome': 'Maria', 'idade': 30})

        # Criar um bucket no S3 com o mesmo nome do bucket real
        self.s3 = boto3.client('s3')
        self.s3.create_bucket(Bucket='teste-fido')

    # Definir um método tearDown que é executado depois de cada teste
    def tearDown(self):
        # Parar o mock do DynamoDB e do S3
        self.mock_dynamodb.stop()
        self.mock_s3.stop()

    # Definir um método que começa com test_
    def test_lambda_handler(self):
        # Chamar a função lambda com um evento e um contexto vazios
        result = lambda_handler({}, {})

        # Verificar se o resultado tem o status code 200 e a mensagem esperada
        self.assertEqual(result['statusCode'], 200)
        self.assertEqual(result['body'], json.dumps('Dados salvos com sucesso no S3!'))

        # Verificar se os dados foram salvos no S3 corretamente
        response = self.s3.get_object(Bucket='teste-fido', Key='tbes2004_web_rgto_crdl')
        data = json.loads(response['Body'].read())
        self.assertEqual(data, [{'id': '1', 'nome': 'João', 'idade': 25}, {'id': '2', 'nome': 'Maria', 'idade': 30}])

# Executar os testes se o arquivo for executado como um script
if __name__ == "__main__":
    unittest.main()
