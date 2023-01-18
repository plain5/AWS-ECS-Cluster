#----------------------- Launch template creation ---------------------

resource "aws_launch_template" "template_for_webserver" {
  name_prefix            = "web_server_config_highly_available-"
  image_id               = "ami-00eb0dc604a8124fd"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.template_sg.id]
  user_data              = filebase64("user_data.sh")
  key_name               = "its-us-east1"
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }


  lifecycle {
    create_before_destroy = true
  }
}



#----------------------- Autoscaling Group policy creation -----------------------

resource "aws_autoscaling_policy" "cpu_tracking" {
  name                      = "CPU-Tracking-Policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 10
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
  autoscaling_group_name = aws_autoscaling_group.ag-for-web-server.name
}



#----------------------- Autoscaling Group creation -----------------------

resource "aws_autoscaling_group" "ag-for-web-server" {
  name = "web_servers_ag_highly_available-${aws_launch_template.template_for_webserver.name}"
  launch_template {
    id      = aws_launch_template.template_for_webserver.id
    version = "$Latest"
  }


  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  health_check_type   = "EC2"



  dynamic "tag" {
    for_each = {
      Name  = "ASG Web Server"
      Owner = "Dmytrii"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }

  depends_on = [
    aws_alb_target_group.main_group,
    aws_alb.alb
  ]
}



#-------------- Target group creation -----------------------

resource "aws_alb_target_group" "main_group" {
  name                 = "Main-TG"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main_vpc.id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
  }
}
