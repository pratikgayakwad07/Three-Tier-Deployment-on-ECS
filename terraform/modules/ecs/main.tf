resource "aws_ecs_cluster" "application_cluster" {
  name = "${var.environment}-cluster"
}


resource "aws_ecs_task_definition" "task_def" {
  family                   = "backend"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${var.repo_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_PORT"
          value = "3306"
        }
      ]

      secrets = [
        {
          name      = "DB_USER"
          valueFrom = "${var.db_secret_arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_secret_arn}:password::"
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "service" {
  name            = "${var.environment}-svc"
  cluster         = aws_ecs_cluster.application_cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1

  force_new_deployment = true

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "backend"
    container_port   = var.container_port
  }

  depends_on = [
    aws_ecs_cluster.application_cluster
  ]
}