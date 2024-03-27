terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}
resource "aws_vpc" "test" {
    cidr_block = "172.31.0.0/16"
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.test.id
}

resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.test.id
    cidr_block = "172.31.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.test.id
    cidr_block = "172.31.2.0/24"
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.test.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public.id
}