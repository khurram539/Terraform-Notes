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

# Define the first VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
	Name = "VPC1"
  }
}

# Define the second VPC
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  tags = {
	Name = "VPC2"
  }
}

# Create a VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc1.id
  peer_vpc_id = aws_vpc.vpc2.id
  auto_accept = true

  tags = {
	Name = "VPC Peering between VPC1 and VPC2"
  }
}

# Automatically accept the VPC Peering Connection (if within the same account)
# Note: The `auto_accept` attribute in the `aws_vpc_peering_connection` resource
# handles this automatically if the peering is within the same AWS account.
# If peering across accounts, use the `aws_vpc_peering_connection_accepter` resource.

# Update route tables in VPC1 to route traffic to VPC2 via the peering connection
resource "aws_route" "vpc1_to_vpc2" {
  route_table_id         = aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Update route tables in VPC2 to route traffic to VPC1 via the peering connection
resource "aws_route" "vpc2_to_vpc1" {
  route_table_id         = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}