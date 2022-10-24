# lb.tf | Load Balancer Configuration
resource "aws_lb" "application_load_balancer" {
  #checkov:skip=CKV2_AWS_28: Ensure public facing ALB are protected
  #checkov:skip=CKV_AWS_150:deletion protection disabled for a reason
  #checkov:skip=CKV_AWS_91: No need for access log
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_sg.id]

  enable_deletion_protection = false
  drop_invalid_header_fields = true
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/healthcheck"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener-https" {
  load_balancer_arn = aws_lb.application_load_balancer.id
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "arn:aws:iam::012119841372:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"



  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}