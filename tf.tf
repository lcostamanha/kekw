resource "aws_lb" "nlb" {
  name               = "nlb-jdk11-newvpc-${var.micro_service_name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.private_subnet_one_new, var.private_subnet_two_new, var.private_subnet_three_new]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_container_port
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # Customize based on requirements

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  certificate_arn = var.certificate_arn
}

resource "aws_lb_target_group" "tg" {
  name     = "tg-${var.micro_service_name}"
  port     = var.listener_container_port
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_route53_record" "dns_record" {
  zone_id = var.hosted_zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = aws_lb.nlb.dns_name
    zone_id                = aws_lb.nlb.zone_id
    evaluate_target_health = true
  }
}

variable "micro_service_name" {}
variable "private_subnet_one_new" {}
variable "private_subnet_two_new" {}
variable "private_subnet_three_new" {}
variable "listener_container_port" {}
variable "certificate_arn" {}
variable "vpc_id" {}
variable "hosted_zone_id" {}
variable "dns_name" {}
