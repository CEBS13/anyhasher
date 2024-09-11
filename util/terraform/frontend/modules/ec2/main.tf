resource "aws_instance" "anyhasher_server" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.small"
  key_name      = "anyhasher"
  #tags          = { 
    #Name = var.instance_name 
    #Environment = "Production"
  #}
}

resource "aws_lb_target_group_attachment" "anyhasher-instance" {
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