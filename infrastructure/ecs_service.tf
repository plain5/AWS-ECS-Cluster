resource "aws_ecs_service" "main_service" {
  name                 = "Main-Service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.service.arn
  desired_count        = 1
  iam_role             = "arn:aws:iam::${var.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  force_new_deployment = true
  launch_type          = "EC2"


  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main_group.arn
    container_name   = "django-app"
    container_port   = 8000
  }

  depends_on = [

    aws_ecs_cluster.main,
    aws_alb.alb

  ]

}
