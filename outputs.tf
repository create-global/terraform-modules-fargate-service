output "alb_id" {
  value = aws_alb.main.id
}

output "fqdn" {
  value = local.fqdn
}
