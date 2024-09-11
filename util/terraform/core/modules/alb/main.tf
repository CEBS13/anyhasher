
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
        target_group_arn = aws_lb_target_group.ec2.arn
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

resource "aws_lb_target_group" "ec2" {
    name       = "anyhasher-tg"
    port       = 80
    protocol   = "HTTP"
    vpc_id     = aws_default_vpc.default.id
    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = 200
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

}