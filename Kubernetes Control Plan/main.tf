provider "aws" {
  region = "us-east-1" # Change to your desired region
}

resource "aws_instance" "Kubernetes_Control_Plane" {
  ami                         = "ami-0a5c3558529277641"    # Amazon Linux 2 AMI ID for us-east-1
  instance_type               = "t2.micro"               # Preferred instance type
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
      private_key = file("/home/ubuntu/Khurram-key.pem") # Path to your local PEM key
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y aws-cli",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl"
      
        
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/ubuntu/Khurram-key.pem") # Path to your local PEM key
      host        = self.public_ip
    }
  }
}