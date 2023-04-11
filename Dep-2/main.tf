provider "aws" {
    region = "us-east-1"
     
}
resource "aws_instance" "myec2" {
    ami = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"

    tags = {
        Name = "myec2"
    }

    depends_on = ["aws_instance.myec2db"]
}   

resource "aws_instance" "myec2db" {
    ami = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"

    tags = {
        Name = "DB Server"
    }
}

