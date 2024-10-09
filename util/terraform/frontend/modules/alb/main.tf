provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_lb" "main_lb" {
    name = "anyhasher-alb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.public.ids
    #security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.main_lb.arn
    port = 80
    protocol = "HTTP"
     default_action {
        type             = "forward"
              forward {
        target_group {
          arn    = aws_lb_target_group.green.arn
          weight = 0
        }

        target_group {
          arn    = aws_lb_target_group.blue.arn
          weight = 100
        }
      }
        target_group_arn = aws_lb_target_group.ec2.arn
        #target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:739685044447:targetgroup/anyhasher-tg-01/16ad37833599ce1f"
  }
}

resource "aws_security_group" "alb" {
    name = "anyhasher-alb-sg"
    #vpc_id = var.vpc_id

    ingress{
        from_port   = 80
        to_port     = 80
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