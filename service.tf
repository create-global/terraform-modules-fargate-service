resource "aws_ecs_cluster" "main" {
  name = local.fqsn
  tags = var.tags
}



resource "aws_ecs_service" "main" {
  name            = local.fqsn
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = local.fqsn
    container_port   = var.app_port
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "main" {

  family                   = local.fqsn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution_role.arn
  cpu                      = var.cpu
  memory                   = var.memory



  container_definitions = <<HERE
[
  {
    "cpu": ${var.cpu},
    "essential": true,
    "image": "${var.image}:${var.image_tag}",
    "memory": ${var.memory},
    "name": "${local.fqsn}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
HERE

  tags = var.tags
}
