provider "aws" {
  
}

variable "number_of_servers" {
    description = "Number of servers to create"
    default = 1

  
}


resource "aws_instance" "ec2" {
    ami = "ami-005f9685cb30f234b"
    instance_type = "t2.micro"
    count = var.number_of_servers
}