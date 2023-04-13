variable "dbname" {
    type = string
}

resource "aws_instane" "myec2db" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t3.large"
    subnet_id = "subnet-0f9f26c4f1f9f9f9f"
    vpc_security_group_ids = ["sg-0f9f26c4f1f9f9f9f"]
    tags = {
        Name = var.dbname
    }
}