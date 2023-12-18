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

resource "aws_ami_from_instance" "example" {
  name               = "Gold_Image 12/18/2023"
  source_instance_id = "i-0ce11afb16ba5ebd8"
}

