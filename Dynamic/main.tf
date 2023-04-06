provider "aws" {
  region = "us-east-1"
}

variable "ingressrules" {
  type = list(number)
  default = [ 80,443 ]
}

variable "egressrules" {
  type = list(number)
  default = [ 80,443,25,3306,53,22,8080 ]
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

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
    from_port = port.value
    to_port = port.value
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }

   dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
    from_port = port.value
    to_port = port.value
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }
}