resource "aws_instance" "ansible_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  disable_api_termination     = true
  monitoring                  = true
  ebs_optimized               = false
  count                       = var.instance_count

  tags = {
    Name = "AnsibleServer"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = false
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/root/Khurram-key.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "/root/Khurram-key.pem"
    destination = "/home/ec2-user/Khurram-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install -y git python3 python3-pip",
      "sudo pip3 install boto boto3 awscli",
      "sudo chown ec2-user:ec2-user /home/ec2-user/Khurram-key.pem",
      "sudo chmod 400 /home/ec2-user/Khurram-key.pem",
      "ssh-keygen -t rsa -N '' -f /home/ec2-user/.ssh/id_rsa",
      "cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",
      "chmod 700 /home/ec2-user/.ssh"
    ]
  }
}