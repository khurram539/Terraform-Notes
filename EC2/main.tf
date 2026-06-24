data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"] # Official Red Hat AWS account

  filter {
    name   = "name"
    values = ["RHEL-9.*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "new_instance" {
  ami                         = data.aws_ami.rhel.id
  instance_type               = "t3a.medium"
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = "us-east-1a"
  iam_instance_profile        = "AmazonSSMRoleForInstancesQuickSetup"
  associate_public_ip_address = true
  disable_api_termination     = true
  monitoring                  = true
  ebs_optimized               = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    encrypted   = true
  }

  tags = {
    Name                    = var.instance_name
    Environment             = "Development"
    Application             = "RedHat Satellite"
    OS                      = "RHEL 9.7"
    disable_api_termination = "true"
  }
}