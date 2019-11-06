
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

resource "aws_lb_listener_rule" "primary" {
  listener_arn = "${data.aws_lb_listener.secure.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"
    values = [local.fqdn]
  }
}
