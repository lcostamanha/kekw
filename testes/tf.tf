# Definição do provedor AWS
provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
}

# Criação do Security Group
resource "aws_security_group" "example" {
  name        = "my-security-group"
  description = "Security Group para acesso HTTP/HTTPS"
  vpc_id      = "vpc-12345678"  # Substitua pelo ID da VPC desejada

  # Regra de saída permitindo todo o tráfego (0.0.0.0/0) em HTTP (porta 80) e HTTPS (porta 443)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
