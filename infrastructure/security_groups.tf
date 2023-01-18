#-------------------- SG for ALB -----------------------

resource "aws_security_group" "main_sg" {
  name        = "SG-for-ALB"
  description = "SG-for-ALB"
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "ALB-SG"
    Owner = "Dmytrii"
  }

}



#-------------------- SG for Launch template -----------------------

resource "aws_security_group" "template_sg" {
  name        = "SG-for-LT"
  description = "SG-for-LT"
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "LT-SG"
    Owner = "Dmytrii"
  }

}
