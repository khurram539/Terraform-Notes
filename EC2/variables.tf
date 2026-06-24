variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "Devbox"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "Khurram-key"
}

variable "subnet_id" {
  description = "Subnet to launch the instance in"
  type        = string
  default     = "subnet-08d90b90e9b121c7e"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = ["sg-0e06cf3a9fea0966d", "sg-03128daff9dfed41b"]
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 30
}