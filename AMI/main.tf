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
  name               = "Gold_Image 03/06/2024"
  source_instance_id = "i-0ec378e85dfc2cc2d"
}

