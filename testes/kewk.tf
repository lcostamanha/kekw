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


100 - (avg by (instance) (irate(node_filesystem_free_bytes{mountpoint="/"}[5m])) * 100) / (avg by (instance) (irate(node_filesystem_size_bytes{mountpoint="/"}[5m])) * 100)


Para exportar dados do DynamoDB para o S3 usando o AWS CLI, você pode usar o seguinte comando:

aws dynamodb scan --table-name <table-name> --region <region> --output json | aws s3 cp - s3://<bucket-name>/<file-name>.json

Substitua <table-name> pelo nome da tabela do DynamoDB que você deseja exportar, <region> pela região em que a tabela está localizada, <bucket-name> pelo nome do bucket S3 para onde você deseja exportar os dados e <file-name> pelo nome do arquivo de saída. Certifique-se de ter as permissões necessárias para acessar a tabela do DynamoDB e o bucket S3.

Espero que isso ajude! Se você tiver alguma dúvida ou precisar de mais ajuda, é só falar.