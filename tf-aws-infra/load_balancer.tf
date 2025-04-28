resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  tags = {
    Name = "webapp_lb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_target_group.arn
  }

}


# HTTPS Listener for Load Balancer (Port 443)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = "arn:aws:acm:us-east-1:841162686161:certificate/dfa8c7de-cfb2-403c-a611-c710f1094a86"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_target_group.arn
  }
}

resource "aws_lb_target_group" "webapp_target_group" {
  name        = "webapp-target-group"
  port        = var.application_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "webapp-target-roup"
  }

}