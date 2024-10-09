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
  ami                    = "ami-0361b567db5c34c96"
  instance_type          = "t3a.medium"
  key_name               = "Khurram-key"
    vpc_security_group_ids = ["sg-025028548d0e7a3d0"]
    subnet_id              = "subnet-08d90b90e9b121c7e"
  availability_zone      = "us-east-1a"
  associate_public_ip_address = true
  disable_api_termination = true
  monitoring             = true
  ebs_optimized          = false
  count = 1
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted = false
  }
  
  tags = {
    Name = "Devbox"
    Environment = "Dev"
    
  }
}
