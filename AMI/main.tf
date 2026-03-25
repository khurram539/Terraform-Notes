terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_ami_from_instance" "New_AMI" {
  name               = "RHSA 03/26/2025"
  source_instance_id = "i-05a352937c930c9a5"
}

