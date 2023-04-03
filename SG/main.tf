provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami = "ami-005f9685cb30f234b"
  instance_type = "t2.micro" 
  security_groups = [aws_security_group.SG.name]
}      

resource "aws_security_group" "SG" {
  name = "SG"
  description = "SG"
  vpc_id = "vpc-0b042fdb9eb308448"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
   egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}