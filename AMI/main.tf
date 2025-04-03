terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ami_from_instance" "New_AMI" {
  name               = "Window_Server_2025 04/03/2025"
  source_instance_id = "i-039a926f859a2b808"
}

