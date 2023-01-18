#-------------- Application Load Balancer creation -----------------------

resource "aws_alb" "alb" {
  name            = "web-servers-elb-highly-available"
  security_groups = [aws_security_group.main_sg.id]
  subnets         = [for subnet in aws_subnet.public_subnets : subnet.id]

  tags = {
    Name = "ELB-for-HA-Web-Server"
  }
}



#-------------- Application Load Balancer listeners -----------------------

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.main_group.arn
    type             = "forward"
  }
}



resource "aws_alb_listener" "redirection" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
