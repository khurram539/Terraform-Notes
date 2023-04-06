provider "aws" {
    region = "us-east-1"
}

module "ec2module" {
    source = "./EC2"  
    ec2name = "Name From Module"
}

output "module_output" {
    value = module.ec2module.instance_id  
}