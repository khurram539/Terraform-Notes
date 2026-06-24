output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.new_instance.id
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.new_instance.private_ip
}

output "public_ip" {
  description = "Public IP address (if assigned)"
  value       = aws_instance.new_instance.public_ip
}