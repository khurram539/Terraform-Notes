variable "server_name" {
  type = list(string)
}  

resource "aws_instance" "db" {
    ami = "ami-005f9685cb30f234b"
    instance_type = "t2.micro"
    count = length(var.server_name)
    tags = {
      name =  var.server_name[count.index]
    }  
}

output "PrivateIP" {
    value = aws_instance.db.*.private_ip
}