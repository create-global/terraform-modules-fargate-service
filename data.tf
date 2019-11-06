data "aws_route53_zone" "selected" {
  name = var.domain
}

data "aws_lb" "ingress" {
  arn = "${var.ingress_lb_arn}"
}

data "aws_lb_listener" "secure" {
  arn = "${var.secure_listener_arn}"
}
