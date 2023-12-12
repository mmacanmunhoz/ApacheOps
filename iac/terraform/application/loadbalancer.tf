resource "aws_lb" "this" {
  name               = "myapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = [data.aws_subnets.public.ids[0], data.aws_subnets.public.ids[1]]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name     = "myapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.this.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/info.php"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:us-east-1:177300752486:certificate/7877396f-6fd6-4004-9032-f2e7c8acf18d"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.this.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = ["myapp.pocsarcotech.com"]
    }
  }
}