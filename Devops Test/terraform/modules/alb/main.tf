resource "aws_lb" "alb" {
  name               = "${var.project}-alb-${var.env}"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = var.security_group_ids
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.project}-tg-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check { path = "/" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}
