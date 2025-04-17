provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_secretsmanager_secret" "directory_service_password" {
  name        = "directory-service-password"
  description = "Password for Directory Service d-9067cf25af"
}

resource "aws_secretsmanager_secret_version" "directory_service_password_version" {
  secret_id     = aws_secretsmanager_secret.directory_service_password.id
  secret_string = var.directory_service_password
}

# terraform init
# terraform plan
# terraform apply -var="directory_service_password=your-secure-password"
# Where you see our-secure-password, replace it with your actual secure password.
# This will create a secret in AWS Secrets Manager with the specified password.
# You can then use this secret in your AWS resources or applications as needed.
# Note: Make sure to have the AWS CLI configured with the necessary permissions to create secrets in Secrets Manager.
# Also, ensure that you have the AWS provider installed in your Terraform environment.
# This code creates a secret in AWS Secrets Manager with the specified password.
# The secret can be used for various purposes, such as storing database credentials, API keys, or any sensitive information.