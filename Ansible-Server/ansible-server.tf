provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}
resource "aws_instance" "ansible_server" {
  ami                         = "ami-02a506f01fced5cc4"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.small"                 # Preferred instance type
  key_name                    = "name.pem"                 # Add your key pair name
    vpc_security_group_ids    = ["sg-025028548d0e7a3d0"]   # Add your security group ID
    subnet_id                 = "subnet-08d90b90e9b121c7e" # Add your subnet ID
  availability_zone          =  "us-east-1a"               # Add your availability zone
  associate_public_ip_address = true                       # Assign a public IP address
  disable_api_termination     = true                       # Prevent accidental termination
  monitoring                  = true                       # Enable detailed monitoring
  ebs_optimized               = false                      # Disable EBS optimization
  count                       = 1                          # Create a single instance

  tags = {
    Name = "AnsibleServer"
  }

  root_block_device {
    volume_size = 30 
    volume_type = "gp2" 
    encrypted   = false                   # Unencrypt the root volume
  }

  connection {
    type        = "ssh"                   # Use SSH to connect to the instance
    user        = "ec2-user"              # Default user for Amazon Linux 2
    private_key = file("/root/name.pem")  # Path to your local PEM key
    host        = self.public_ip          # Public IP address of the instance
  }

  provisioner "file" {
    source      = "/root/Khurram-key.pem"    # Path to your local PEM key
    destination = "/home/ec2-user/name.pem"  # Destination path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",                           # Update the instance
      "sudo amazon-linux-extras install ansible2 -y", # Install Ansible
      "sudo yum install -y git python3 python3-pip",  # Install Git, Python3, and Pip3
      "sudo pip3 install boto boto3 awscli",                   # Install Boto, Boto3, and AWS CLI
      "sudo chown ec2-user:ec2-user /home/ec2-user/name.pem",  # Change ownership of the PEM key
      "sudo chmod 400 /home/ec2-user/name.pem",                # Change permissions of the PEM key
      "ssh-keygen -t rsa -N '' -f /home/ec2-user/.ssh/id_rsa", # Generate SSH key pair
      "cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys", # Add public key to authorized_keys
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",                             # Change permissions of authorized_keys
      "chmod 700 /home/ec2-user/.ssh"                                              # Change permissions of .ssh directory
    ]
  }
}

output "ansible_server_ip" {
  value = aws_instance.ansible_server[0].public_ip # Output the public IP address of the instance
}