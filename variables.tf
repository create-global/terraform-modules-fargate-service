variable "service_name" {}
variable "namespace" {}
variable "image" {}
variable "image_tag" {}
variable "app_port" {}
variable "domain" {}
variable "subdomain" {}

variable "vpc_id" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "tags" {}
variable "ingress_lb_arn" {}
variable "secure_listener_arn" {}

variable "cpu" {
  default = 512
}
variable "memory" {
  default = 1024
}

variable "env" {
  type = map(string)
}

variable "log_retention" {
  default = 7
}

variable "ingress_security_groups" {
  type    = list
  default = []
}

variable "task_security_groups" {
  type    = list
  default = []
}

variable "health_check_path" {
  type    = string
  default = "/"
}


variable "task_policy" {
  default = <<TP
{
  "Version": "2012-10-17",
  "Statement": []
}
TP
}
