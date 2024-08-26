variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "vpc1_cidr" {
  description = "CIDR block for the first VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc2_cidr" {
  description = "CIDR block for the second VPC"
  type        = string
  default     = "10.1.0.0/16"
}