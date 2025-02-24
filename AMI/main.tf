terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_ami_from_instance" "New_AMI" {
  name               = "Gold_Image 11/01/2024"
  source_instance_id = "i-0d7f82dd1e3a960af"
}
