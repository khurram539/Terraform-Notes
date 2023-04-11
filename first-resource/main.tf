# strings

variable "vpcname" {
    type = string 
    default = "myvbp"
}

# numbers

variable "shport" {
    type = number
    default = 22
}

# booleans

variable "enabled" {
    default = true
}

# lists

variable "mylist" {
    type = list(string)
    default = ["a", "b", "c"] 
}

# how to use stings


resource "aws_vpv" "myvpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = var.vpcname
    }
}

# how to use lists

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = var.vpcname
        Environment = var.mylist[0]
    }
}

# how to use maps

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = var.vpcname
        Environment = var.mylist[0]
        Owner = var.mylist[1]
    }
  
}

# input variables

variable "inputname" {
    type = string
    description = "value to be used as name"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = var.inputname
    }
  
}

# output variables

output "myoutput" {
    value = aws_vpc.myvpc.id
}

# dynamic blocks

provider "aws" {
    region = "us-east-1"
  
}

variable "ingress_rulles" {
    type = list(map(string))
    default = [
        {
            from_port = "22"
            to_port = "22"
            protocol = "tcp"
            cidr_blocks = "10.0.0.0/16"
  
        },
        {
            from_port = "80"
            to_port = "80"
            protocol = "tcp"
            cidr_blocks = "10.0.0.0/16"
        }
    ]
}

variable "egress_rulles" {
    type = list(map(string))
    default = [
        {
            from_port = "0"
            to_port = "0"
            protocol = "-1"
            cidr_blocks = "10.0.0.0/16"
        }
    ]
      
}

resource "aws_instace" "myec2instance" {
    ami = "ami-0c2b8ca1dad447f8a"
    instance_type = "t3.me"
    vpc_security_group_ids = [aws_security_group.mysecuritygroup.id]

    tags = {
        Name = "myec2instance"
    }
  
}


variable "mytuple" {
    type = tuple([string, number, string])
    default = ["cat", 42, "dog"]

  
}


variable "myobject" {
    type = object([{ name = string, age = list(number) }])
    default = {
        name = "John"
        age = [42, 43, 44]
        port = [22, 25, 80]
    }
}

