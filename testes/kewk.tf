provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
}

resource "aws_security_group" "example" {
  name        = "meu-security-group"
  description = "Grupo de segurança com regra de saída para HTTPS"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
