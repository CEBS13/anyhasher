provider "aws" {
  region = "us-east-1"
}

variable "instance_name" {
  type    = string
  default = "default-instance-name"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

variable "target_group_name" {
  type    = string
  default = "default-tg"
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_instance" "anyhasher_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t3.small"
  key_name      = "anyhasher"

  tags = { 
    Name        = var.instance_name
    Environment = "Production"
  }
}

resource "aws_lb_target_group" "ec2" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "anyhasher_instance" {
  target_group_arn = aws_lb_target_group.ec2.arn
  target_id        = aws_instance.anyhasher_server.id
  port             = 3000
}

output "ec2_frontend_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}

output "ec2_frontend_public_url" {
  value = aws_instance.anyhasher_server.public_dns
}

output "ec2_frontend_instance_id" {
  value = aws_instance.anyhasher_server.id
}
