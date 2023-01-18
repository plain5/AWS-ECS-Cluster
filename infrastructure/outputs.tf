output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}



output "main_vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}



output "public_subnets_ids" {
  value = aws_subnet.public_subnets[*].id
}



output "dns_name" {
  value = aws_route53_record.alb-record.name
}



output "launch_template_sg_id" {
  value = aws_security_group.template_sg.id
}



output "alb_sg_id" {
  value = aws_security_group.main_sg.id
}



output "task_definition_id" {
  value = aws_ecs_task_definition.service.id
}



output "task_definition_arn" {
  value = aws_ecs_task_definition.service.arn
}



output "ecs_agent_ec2_role_arn" {
  value = aws_iam_role.ecs_agent.arn
}



output "ecs_service_role_id" {
  value = aws_ecs_service.main_service.id
}



output "ecs_service_role_launch_type" {
  value = aws_ecs_service.main_service.launch_type
}



output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}



output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}



output "ecr_uri" {
  value = var.ecr_uri
}
