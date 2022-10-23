resource "aws_security_group" "load_balancer_sg" {
  #checkov:skip=CKV_AWS_260: allow ingress from 0.0.0.0/0 to port 80 for testing
  name        = "alb-sg"
  description = "Allow inbound traffic to Load Balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    description      = "Allow inbound access"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    description      = "Allow outbound access"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    description     = "Allow inbound access"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    description      = "Allow outbound access"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}