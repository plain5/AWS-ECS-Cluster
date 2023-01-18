resource "aws_ecs_task_definition" "service" {
  family                   = "django-application"
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name      = "migration"
      image     = "${var.ecr_uri}"
      essential = false
      command   = ["python", "manage.py", "migrate"]
      memory    = 128
      environment = [
        { "name" : "DEBUG", "value" : "False" },
        { "name" : "DJANGO_ALLOWED_HOSTS", "value" : "*" },
        { "name" : "DEVELOPMENT_MODE", "value" : "False" }
      ]
      secrets = [
        { "name" : "DATABASE_URL", "valueFrom" : "DATABASE_URL" },
        { "name" : "DJANGO_SECRET_KEY", "valueFrom" : "DJANGO_SECRET_KEY" }
      ]
    },
    {
      name      = "django-app"
      image     = "${var.ecr_uri}"
      essential = true
      memory    = 128
      environment = [
        { "name" : "DEBUG", "value" : "False" },
        { "name" : "DJANGO_ALLOWED_HOSTS", "value" : "*" },
        { "name" : "DEVELOPMENT_MODE", "value" : "False" }
      ]
      secrets = [
        { "name" : "DATABASE_URL", "valueFrom" : "DATABASE_URL" },
        { "name" : "DJANGO_SECRET_KEY", "valueFrom" : "DJANGO_SECRET_KEY" }
      ]
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 80
        }
      ]
      depends_on = [
        { "containerName" : "migration", "condition" : "SUCCESS" }
      ]
    }
  ])

  lifecycle {
    create_before_destroy = true
  }

}
