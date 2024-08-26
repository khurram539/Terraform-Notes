provider "aws" {
  region = var.aws_region
}

# Create the first VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc1_cidr
  tags = {
    Name = "VPC1"
  }
}

# Create the second VPC
resource "aws_vpc" "vpc2" {
  cidr_block = var.vpc2_cidr
  tags = {
    Name = "VPC2"
  }
}

# Create VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  auto_accept   = true

  tags = {
    Name = "VPC1-to-VPC2"
  }
}

# Update route table for VPC1
resource "aws_route" "vpc1_to_vpc2" {
  route_table_id         = aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = var.vpc2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Update route table for VPC2
resource "aws_route" "vpc2_to_vpc1" {
  route_table_id         = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}