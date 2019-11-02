output "alb_id" {
  value = aws_alb.main.id
}

output "sg_tasks_id" {
  value = aws_security_group.ecs_tasks.id
}

output "sq_alb_id" {
  value = aws_security_group.lb.id
}

output "fqdn" {
    value = local.fqdn
}