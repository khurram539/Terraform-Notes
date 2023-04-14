provider = "aws" {
  region = "us-east-1"
}

resoure "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main"
    }
}

resoure "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main"
    }
}


# terraform init, plan , and apply


# when state is out of sync, use "Terraform refresh" to resync it
# Terraform refresh will not modify infrastructure, but does modify the state file
# it will qurry the statefile and update the state with the real-world infrastructure