provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_instance" "ansible_server" {
  ami                         = "ami-02a506f01fced5cc4"  # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.small"
  vpc_security_group_ids      = ["sg-025028548d0e7a3d0"]  # Add your security group ID
  subnet_id                   = "subnet-08d90b90e9b121c7e"  # Add your subnet ID
  associate_public_ip_address = true
  disable_api_termination     = true
  monitoring                  = true
  ebs_optimized               = false
  count                       = 1
  

  tags = {
    Name = "AnsibleServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      "'sudo yum install python3 -y",
      "sudo yum install python3-pip -y",
      "sudo pip3 install boto boto3",
      "sudo pip3 install awscli"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/root/Khurram-key.pem")  # Change to the path of your private key
      host        = self.public_ip
    }
  }
}

output "ansible_server_ip" {
  value = aws_instance.ansible_server[0].public_ip
}