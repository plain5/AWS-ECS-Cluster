#-------------- IAM Role -----------------------

resource "aws_iam_role" "ecs_agent" {
  name = "ecs_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}



#-------------- IAM instance profile -----------------------

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}



#-------------- IAM policy attachment -----------------------

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = data.aws_iam_policy.ecs_agent.arn
}
