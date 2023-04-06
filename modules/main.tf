provider "aws" {
    region = "us-east-1"
}

module "ec2module" {
    source = "./EC2"  
    ec2name = "Name From Module"
}