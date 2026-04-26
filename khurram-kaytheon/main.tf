# -------------------------------
# PROVIDERS
# -------------------------------
provider "aws" {
  alias   = "account1"
  region  = "us-east-1"
  profile = "163544304364"
}

provider "aws" {
  alias   = "account2"
  region  = "us-east-1"
  profile = "396913703931"
}

# -------------------------------
# VPC PEERING (Requester - Account 1)
# -------------------------------
resource "aws_vpc_peering_connection" "peer" {
  provider      = aws.account1
  vpc_id        = "vpc-0f238901bc3467b62"
  peer_vpc_id   = "vpc-05b44d48e309cf3b7"
  peer_owner_id = "396913703931"
  auto_accept   = false

  tags = {
    Name = "account1-to-account2-peering"
  }
}

# -------------------------------
# ACCEPT PEERING (Account 2)
# -------------------------------
resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Name = "account2-accept-peering"
  }
}

# -------------------------------
# ENABLE DNS RESOLUTION (Requester)
# -------------------------------
resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.account1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.peer_accept
  ]
}

# -------------------------------
# ENABLE DNS RESOLUTION (Accepter)
# -------------------------------
resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.peer_accept
  ]
}

# -------------------------------
# ROUTE: Account 1 → Account 2
# -------------------------------
resource "aws_route" "account1_to_account2" {
  provider                  = aws.account1
  route_table_id            = "rtb-049c4395cbe56a7bb"
  destination_cidr_block    = "10.90.0.0/20"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# -------------------------------
# ROUTE: Account 2 → Account 1
# -------------------------------
resource "aws_route" "account2_to_account1" {
  provider                  = aws.account2
  route_table_id            = "rtb-015eb11135a1e84ca"
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# -------------------------------
# SECURITY GROUP - Account 1
# -------------------------------
resource "aws_security_group_rule" "account1_ingress" {
  provider          = aws.account1
  type              = "ingress"
  security_group_id = "sg-039aa170f6aac3f1a"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.90.0.0/20"]
}

# -------------------------------
# SECURITY GROUP - Account 2
# -------------------------------
resource "aws_security_group_rule" "account2_ingress" {
  provider          = aws.account2
  type              = "ingress"
  security_group_id = "sg-06ea0865e92179e23"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["172.31.0.0/16"]
}
