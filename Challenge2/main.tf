provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "db" {
    ami = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"
    
    tags = {
        Name = "DB Server"
    }
}
    
resource "aws_instance" "web" {
    ami = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.web_traffic.name]
    user_data = file("server-script.sh")
    tags = {
        Name = "Web Server"
    }
}

resource "aws_eip" "web_ip" {
    instance = aws_instance.web.id
}  

variable "ingress" {
    type = list(number)
    default = [443, 80]
}  

variable "egress" {
    type = list(number)
    default = [443, 80]
}

resource "aws_security_group" "web_traffic" {
    name = "Allow Web Traffic"
    
    dynamic "ingress" {
        iterator = port
        for_each = var.ingress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0./0"]         
        }
    }   
}
        dynamic "egress" {
        iterator = port
        for_each = var.egress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0./0"]         
        }
    }      
       

output "private_ip" {
    value = "aws_instance.db.private_ip"
}
output "public_ip" {
    value = "aws_eip.web_ip.public_ip"
}
          