#------------- Data ----------------

data "aws_availability_zones" "alive" {}






data "aws_route53_zone" "selected" {
  name = "guard-lite.com"
}



data "aws_iam_policy" "ecs_agent" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
