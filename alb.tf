resource "aws_alb" "main" {
  name            = local.fqsn
  subnets         = var.public_subnets
  security_groups = var.ingress_security_groups
  tags            = var.tags
}

resource "aws_alb_target_group" "app" {
  name        = local.fqsn
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = var.health_check_path
  }

  depends_on = ["aws_alb.main"]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "insecure" {
  load_balancer_arn = aws_alb.main.id
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

resource "aws_alb_listener" "secure" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}


