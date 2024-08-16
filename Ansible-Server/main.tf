provider "aws" {
  region = var.region
}

module "ansible_server" {
  source = "./modules/ansible_server"

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  volume_size                 = var.volume_size
  volume_type                 = var.volume_type
  instance_count              = var.instance_count
}

output "ansible_server_ip" {
  value = module.ansible_server.ansible_server_ip
}