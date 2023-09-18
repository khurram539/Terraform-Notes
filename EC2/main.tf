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

resource "aws_instance" "DevOps2" {
  ami                    = "ami-0b7e8ccd689a48950"
  instance_type          = "t3.medium"
  key_name               = "Khurram-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-025028548d0e7a3d0"]
  associate_public_ip_address = true
  subnet_id              = "subnet-08d90b90e9b121c7e"



  tags = {
    Name = "DevOps2"
  }
}
