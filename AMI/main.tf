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
  name               = "RHSA 04/25/2026"
  source_instance_id = "i-07b7d2d0e164635cc"
}

