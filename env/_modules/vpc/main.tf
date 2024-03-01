#create vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.vpc_name}-vpc-${var.env}"
  }
}

#create internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw-${var.env}"
  }
}

#create public subnet a
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "AZ A - Public"
  }
}

#create public subnet b
resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "AZ B - Public"
  }
}

#create public subnet c
resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_c_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "AZ C - Public"
  }
}

#create private subnet a
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "AZ A - Private"
  }
}

#create private subnet b
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "AZ B - Private"
  }
}

#create private subnet c
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "AZ C - Private"
  }
}

#create nat gateway a
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "AZ A NAT Gateway"
  }
}

#create nat gateway b
resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "AZ B NAT Gateway"
  }
}

#create nat gateway c
resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.public_c.id

  tags = {
    Name = "AZ C NAT Gateway"
  }
}

#create elastic ip for nat gateway a
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "AZ A NAT Gateway"
  }
}

#create elastic ip for nat gateway b
resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "AZ B NAT Gateway"
  }
}

#create elastic ip for nat gateway c
resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "AZ C NAT Gateway"
  }
}

#create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Tablet Command Public Route Table"
  }
}

#create private route table a
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "Tablet Command AZ A Private Route Table"
  }
}

#create private route table b
resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = {
    Name = "Tablet Command AZ B Private Route Table"
  }
}

#create private route table c
resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_c.id
  }

  tags = {
    Name = "Tablet Command AZ C Private Route Table"
  }
}

#create public subnet a association
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

#create public subnet b association
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

#create public subnet c association
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

#create private subnet a association
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

#create private subnet b association
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

#create private subnet c association
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}

#set public route table as main
resource "aws_main_route_table_association" "public" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}

#create s3 endpoint for vpc
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  tags = {
    Name = "VPC Endpoint - S3"
  }
}

#create s3 endpoint private subnet a association
resource "aws_vpc_endpoint_route_table_association" "s3_a" {
  route_table_id  = aws_route_table.private_a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

#create s3 endpoint private subnet b association
resource "aws_vpc_endpoint_route_table_association" "s3_b" {
  route_table_id  = aws_route_table.private_b.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

#create s3 endpoint private subnet c association
resource "aws_vpc_endpoint_route_table_association" "s3_c" {
  route_table_id  = aws_route_table.private_c.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
