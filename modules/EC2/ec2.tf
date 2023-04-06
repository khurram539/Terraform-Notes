variable "ec2name" {
    type = string
}  

resource "aws_instane" "ec2" {
    ami = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"
    tags = {
        Name = var.ec2name
    }
}     
