# AWS Create ec2 instance

provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "ec2" {
  ami = "ami-005f9685cb30f234b"
  instance_type = "t2.micro" 
}      

# AWS Create VPC - Name myvpc

provider = "aws" {
  region = "us-east-1"
}
resource "aws_" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "myvpc"
    }
