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
      "sudo chmod 400 /home/ec2-user/Khurram-key.pem",                # Change permissions of the PEM key
      "ssh-keygen -t rsa -N '' -f /home/ec2-user/.ssh/id_rsa",        # Generate SSH key pair
      "cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys", # Add public key to authorized_keys
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",                             # Change permissions of authorized_keys
      "chmod 700 /home/ec2-user/.ssh"                                              # Change permissions of .ssh directory
    ]
  }
}

output "ansible_server_ip" {
  value = aws_instance.ansible_server[0].public_ip                                 # Output the public IP address of the instance
}



# This code creates an Amazon EC2 instance with the following configuration:

# - AMI: Amazon Linux 2 AMI ID for us-east-1 region
# - Instance type: t2.small
# - Key pair name: Khurram-key
# - Security group ID: sg-025028548d0e7a3d0
# - Subnet ID: subnet-08d90b90e9b121c7e
# - Availability zone: us-east-1a
# - Instance name: AnsibleServer
# - Root volume size: 50 GB
# - Root volume type: gp2
# - Disable API termination: true
# - Detailed monitoring: true
# - Unencrypted root volume: false

# The code also includes a provisioner block to transfer the local PEM key file to the remote instance and configure the instance with Ansible, Git, Python3, and Pip3. It also generates an SSH key pair and adds the public key to the authorized_keys file on the instance.

# After running this code, you will have an Amazon EC2 instance running with Ansible installed, Git, Python3, and Pip3 pre-configured, and an SSH key pair generated. You can then use this key pair to connect to the instance using SSH or Ansible.

# Note: Make sure to replace `/root/Khurram-key.pem` with the actual path to your local PEM key file.