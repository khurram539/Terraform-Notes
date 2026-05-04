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
  ami                    = "ami-08a06634f0da195a3"
  instance_type          = "t3a.medium"
  key_name               = "Khurram-key"
    vpc_security_group_ids = ["sg-0e06cf3a9fea0966d", "sg-03128daff9dfed41b"]
    subnet_id              = "subnet-08d90b90e9b121c7e"
  availability_zone      = "us-east-1a"
  iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
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
    Environment = "Development"
    Application = "RedHat Satellite"
    OS = "RHEL 9.7"
    
  }
  
}
