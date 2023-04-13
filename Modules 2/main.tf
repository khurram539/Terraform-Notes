provisioner "aws" {
    region = "us-east-1"

}



resource "aws_instance" "webserver" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name = "mykey"
    tags = {
        Name = "webserver"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y apache2"
        ]
    }
    provisioner "file" {
        source = "index.html"
        destination = "/var/www/html/index.html"
    }
}

module "dbserver" {
    source = "./db"
    dbname = "mydbserver"
    
}

output "dbprivateip" {
    value = module.dbserver.privateip
}