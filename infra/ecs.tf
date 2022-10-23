#ecs.tf | Elastic Container Service Cluster and Taks Configuration

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.app_name}-${var.environment}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs-task" {
  family = "${var.app_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_name}-${var.environment}-container",
      "image": "${aws_ecr_repository.ecr.repository_url}:latest",
      "entryPoint": [],
      "environment": ${var.environment},
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.app_name}-${var.environment}"
        }
      },
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  /* task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn */
  depends_on               = [aws_cloudwatch_log_group.log-group]
}

resource "aws_cloudwatch_log_group" "log-group" {
  #checkov:skip=CKV_AWS_158: Ensure that CloudWatch Log Group is encrypted by KMS
  
  name = "${var.app_name}-${var.environment}-logs"

  retention_in_days = 90
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.ecs-task.family
}

resource "aws_ecs_service" "ecs-service" {
  name                 = "${var.app_name}-${var.environment}-ecs-service"
  cluster              = aws_ecs_cluster.ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.ecs-task.family}:${max(aws_ecs_task_definition.ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-${var.environment}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]
}