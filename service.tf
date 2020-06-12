resource "aws_ecs_cluster" "main" {
  name = local.fqsn
  tags = var.tags
}



resource "aws_ecs_service" "main" {
  name             = local.fqsn
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.main.arn
  desired_count    = 1
  propagate_tags   = "SERVICE"
  launch_type      = "FARGATE"

  network_configuration {
    security_groups = var.task_security_groups
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

  depends_on = ["aws_alb_target_group.app"]

  tags = var.tags
}

resource "aws_ecs_task_definition" "main" {

  family                   = local.fqsn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
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
    "environment": ${jsonencode(local.env)},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options" : {
        "awslogs-group": "${local.fqsn}",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "${local.fqsn}"
      }
    },
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


resource "aws_cloudwatch_log_group" "log-group" {
  name              = local.fqsn
  retention_in_days = var.log_retention

  tags = var.tags
}
