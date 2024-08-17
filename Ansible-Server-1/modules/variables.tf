variable "ami" {
  description = "The AMI ID to use for the instance"
}

variable "instance_type" {
  description = "The instance type to use"
}

variable "key_name" {
  description = "The name of the key pair to use"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with"
  type        = list(string)
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
}

variable "availability_zone" {
  description = "The availability zone to launch the instance in"
}

variable "volume_size" {
  description = "The size of the root volume"
}

variable "volume_type" {
  description = "The type of the root volume"
}

variable "instance_count" {
  description = "The number of instances to create"
}