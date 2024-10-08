provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}
resource "aws_instance" "ansible_server" {
  ami                         = "ami-0ae8f15ae66fe8cda"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.small"                 # Preferred instance type
  key_name                    = "Khurram-key"              # Add your key pair name
    vpc_security_group_ids    = ["sg-025028548d0e7a3d0"]   # Add your security group ID
    subnet_id                 = "subnet-08d90b90e9b121c7e" # Add your subnet ID
  availability_zone           =  "us-east-1a"              # Add your availability zone
  associate_public_ip_address = true                       # Assign a public IP address
  disable_api_termination     = true                       # Prevent accidental termination
  monitoring                  = true                       # Enable detailed monitoring
  ebs_optimized               = false                      # Disable EBS optimization
  count                       = 1                          # Create a single instance

  tags = {
    Name = "AnsibleServer"                                 # Instance name
  }

  root_block_device {
    volume_size = 50                                       # Root volume size in GB
    volume_type = "gp2"                                    # General Purpose SSD
    encrypted   = false                                    # Unencrypt the root volume
  }

  connection {
    type        = "ssh"                                    # Use SSH to connect to the instance
    user        = "ec2-user"                               # Default user for Amazon Linux 2
    private_key = file("/root/Khurram-key.pem")            # Path to your local PEM key
    host        = self.public_ip                           # Public IP address of the instance
  }

  provisioner "file" {
    source      = "/root/Khurram-key.pem"                 # Path to your local PEM key
    destination = "/home/ec2-user/Khurram-key.pem"        # Destination path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",                                           # Update the instance
      "sudo amazon-linux-extras install ansible2 -y",                 # Install Ansible
      "sudo yum install -y git python3 python3-pip",                  # Install Git, Python3, and Pip3
      "sudo pip3 install boto boto3 awscli",                          # Install Boto, Boto3, and AWS CLI
      "sudo chown ec2-user:ec2-user /home/ec2-user/Khurram-key.pem",  # Change ownership of the PEM key
      "sudo chmod 400 /home/ec2-user/name.pem",                       # Change permissions of the PEM key
      "ssh-keygen -t rsa -N '' -f /home/ec2-user/.ssh/id_rsa",        # Generate SSH key pair
      "cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys", # Add public key to authorized_keys
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",                             # Change permissions of authorized_keys
      "chmod 700 /home/ec2-user/.ssh"                                              # Change permissions of .ssh directory
    ]
  }
}

resource "aws_instance" "web_server" {
  ami                         = "ami-0ae8f15ae66fe8cda"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.micro"                 # Preferred instance type
  key_name                    = "Khurram-key"              # Add your key pair name
  vpc_security_group_ids      = ["sg-025028548d0e7a3d0"]   # Add your security group ID
  subnet_id                   = "subnet-08d90b90e9b121c7e" # Add your subnet ID
  availability_zone           = "us-east-1a"               # Add your availability zone
  associate_public_ip_address = true                       # Assign a public IP address
  disable_api_termination     = true                       # Prevent accidental termination
  monitoring                  = true                       # Enable detailed monitoring
  ebs_optimized               = false                      # Disable EBS optimization
  count                       = 2                          # Create two instances
  tags = {
    Name = "WebServer"                                     # Instance name
  }

  root_block_device {
    volume_size = 20                                       # Root volume size in GB
    volume_type = "gp2"                                    # General Purpose SSD
    encrypted   = false                                    # Unencrypt the root volume
  }
}

resource "aws_instance" "db_server" {
  ami                         = "ami-0ae8f15ae66fe8cda"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.micro"                 # Preferred instance type
  key_name                    = "Khurram-key"              # Add your key pair name
  vpc_security_group_ids      = ["sg-025028548d0e7a3d0"]   # Add your security group ID
  subnet_id                   = "subnet-08d90b90e9b121c7e" # Add your subnet ID
  availability_zone           = "us-east-1a"               # Add your availability zone
  associate_public_ip_address = true                       # Assign a public IP address
  disable_api_termination     = true                       # Prevent accidental termination
  monitoring                  = true                       # Enable detailed monitoring
  ebs_optimized               = false                      # Disable EBS optimization
  count                       = 2                          # Create two instances

  tags = {
    Name = "DBServer"                                      # Instance name
  }

  root_block_device {
    volume_size = 20                                       # Root volume size in GB
    volume_type = "gp2"                                    # General Purpose SSD
    encrypted   = false                                    # Unencrypt the root volume
  }
}

output "ansible_server_ip" {
  value = aws_instance.ansible_server[0].public_ip                                 # Output the public IP address of the instance
}

output "web_server_ips" {
  value = aws_instance.web_server[*].public_ip                                     # Output the public IP addresses of the instances
}

output "db_server_ips" {
  value = aws_instance.db_server[*].public_ip                                      # Output the public IP addresses of the instances
}
