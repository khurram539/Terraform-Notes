terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "new_instance" {
  ami                         = "ami-0b88848780d62be43"
  instance_type               = "m5.xlarge"
  key_name                    = "Khurram-key"
  vpc_security_group_ids      = ["sg-025028548d0e7a3d0"]
  subnet_id                   = "subnet-08d90b90e9b121c7e"
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  disable_api_termination    = true
  monitoring                 = true
  ebs_optimized              = true
  count                      = 1

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update package list and upgrade all packages
              sudo apt update
              sudo apt upgrade -y
              sudo apt dist-upgrade -y

              # Remove old kernels and unnecessary files
              sudo apt autoremove -y
              sudo apt-get clean

              # Install pip if not already installed
              sudo apt install python3-pip -y

              # List and update pip packages
              pip list --outdated
              sleep 3

              # Generate list of outdated packages
              pip list --outdated --format=columns 

              # Update each package
              for pkg in $(pip list --outdated --format=columns | awk 'NR>2 {print $1}')
              do
                  pip install --upgrade $pkg
              done

              # Final check
              pip list --outdated
              sleep 3

              # Final system update
              sudo apt update
              EOF

  tags = {
    Name        = "ubuntu Desktop"
    Application = "Webull"
  }
}

# Create Elastic IP
resource "aws_eip" "instance_eip" {
  domain = "vpc"
  
  tags = {
    Name        = "ubuntu-desktop-eip"
    Application = "Webull"
  }
}

# Associate EIP with EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.new_instance[0].id
  allocation_id = aws_eip.instance_eip.id
}

# Optional: Add output to see the EIP
output "elastic_ip" {
  value = aws_eip.instance_eip.public_ip
}
