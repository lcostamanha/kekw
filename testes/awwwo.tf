resource "aws_security_group" "asg_fido" {
  name        = var.name
  description = "Security Group para acesso HTTP/HTTPS"
  vpc_id      = var.vpc_id # Substitua pelo ID da VPC desejada

  # Regra de entrada permitindo todo o tráfego da própria subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true # Permitir tráfego da mesma fonte (neste caso, a própria subnet)
  }

  # Regra de saída permitindo todo o tráfego (0.0.0.0/0) em qualquer porta
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
