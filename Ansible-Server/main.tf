provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ansible_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "AnsibleServer"
  }
}

# Remove this block if you want to keep the output in outputs.tf
# output "ansible_server_ip" {
#   value = aws_instance.ansible_server.public_ip
# }