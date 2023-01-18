#--------------------- VPC creation ---------------------

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Main VPC"
  }
}



#--------------------- IGW creation ---------------------

resource "aws_internet_gateway" "igw_main_vpc" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "IGW for main VPC"
  }
}



#--------------------- Public subnets creation ---------------------

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr_blocks)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnets_cidr_blocks, count.index)
  availability_zone       = data.aws_availability_zones.alive.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet N${count.index + 1}"
  }
}



#--------------------- Route table creation ---------------------

resource "aws_route_table" "rt_for_public_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main_vpc.id
  }

  tags = {
    Name = "Route table for public subnets"
  }
}



#--------------------- Route table attaching ---------------------

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.rt_for_public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
