resource "aws_lb" "search_head" {
  name_prefix        = "sh-alb"
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]

  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = true

  tags = merge(var.tags, { Name = "${var.name}-alb" })
}

resource "aws_lb_target_group" "search_head" {
  name_prefix = "sh-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = var.health_check_interval
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.stickiness_duration
    enabled         = true
  }

  deregistration_delay = var.deregistration_delay

  tags = merge(var.tags, { Name = "${var.name}-tg" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.search_head.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.search_head.arn
  }
}