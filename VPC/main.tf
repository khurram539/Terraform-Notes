terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ExampleVPC"
  }
}

resource "aws_subnet" "example_subnet_1" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ExampleSubnet1"
  }
}

resource "aws_subnet" "example_subnet_2" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "ExampleSubnet2"
  }
}

resource "aws_subnet" "example_subnet_3" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "ExampleSubnet3"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "ExampleInternetGateway"
  }
}

resource "aws_route_table" "example_rt_public_1" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExamplePublicRouteTable1"
  }
}

resource "aws_route_table_association" "example_rta_public_1" {
  subnet_id      = aws_subnet.example_subnet_1.id
  route_table_id = aws_route_table.example_rt_public_1.id
}

resource "aws_route_table" "example_rt_public_2" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExamplePublicRouteTable2"
  }
}

resource "aws_route_table_association" "example_rta_public_2" {
  subnet_id      = aws_subnet.example_subnet_2.id
  route_table_id = aws_route_table.example_rt_public_2.id
}

resource "aws_route_table" "example_rt_public_3" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExamplePublicRouteTable3"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Security group that allows all inbound and outbound traffic"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 signifies all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 signifies all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowAllTraffic"
  }
}

resource "aws_route_table_association" "example_rta_public_3" {
  subnet_id      = aws_subnet.example_subnet_3.id
  route_table_id = aws_route_table.example_rt_public_3.id
}