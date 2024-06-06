terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_ami_from_instance" "New_AMI" {
  name               = "Gold_Image 06/03/2024"
  source_instance_id = "i-029006dee59f17b75"
}