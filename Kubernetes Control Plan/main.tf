provider "aws" {
  region = "us-east-1" # Change to your desired region
}

resource "aws_instance" "Kubernetes_Control_Plane" {
  ami                         = "ami-01579e3c813e9114f"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t3a.medium"               # Preferred instance type
  key_name                    = "Khurram-key"              # Add your key pair name
  vpc_security_group_ids      = ["sg-025028548d0e7a3d0"]   # Add your security group ID
  subnet_id                   = "subnet-08d90b90e9b121c7e" # Add your subnet ID
  availability_zone           = "us-east-1a"               # Add your availability zone
  associate_public_ip_address = true                       # Assign a public IP address
  disable_api_termination     = false                      # Allow API termination
  monitoring                  = true                       # Enable detailed monitoring
  ebs_optimized               = false                      # Disable EBS optimization
  count                       = 1                          # Create a single instance

  tags = {
    Name = "Kubernetes Control Plane"
    OS   = "Amazon Linux 2"
  }

  provisioner "file" {
    source      = "/home/ubuntu/Khurram-key.pem" # Path to your local PEM key
    destination = "/home/ec2-user/Khurram-key.pem" # Destination path on the remote instance

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/ubuntu/Khurram-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y aws-cli",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "curl -LO 'https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'",
      "chmod +x kubectl",
      "sudo mv kubectl /usr/local/bin/",
      "curl --silent --location 'https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz' | tar xz -C /usr/local/bin",
      "chmod +x /usr/local/bin/eksctl",
      "echo 'Instance Setup Complete!'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/ubuntu/Khurram-key.pem")
      host        = self.public_ip
    }
  }
}