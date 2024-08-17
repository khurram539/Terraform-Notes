variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  default     = "ami-02a506f01fced5cc4"
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.small"
}

variable "key_name" {
  description = "The name of the key pair to use"
  default     = "Khurram-key.pem"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with"
  type        = list(string)
  default     = ["sg-025028548d0e7a3d0"]
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  default     = "subnet-08d90b90e9b121c7e"
}

variable "availability_zone" {
  description = "The availability zone to launch the instance in"
  default     = "us-east-1a"
}

variable "volume_size" {
  description = "The size of the root volume"
  default     = 30
}

variable "volume_type" {
  description = "The type of the root volume"
  default     = "gp2"
}

variable "instance_count" {
  description = "The number of instances to create"
  default     = 1
}