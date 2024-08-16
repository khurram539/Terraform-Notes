output "ansible_server_ip" {
  value       = aws_instance.ansible_server.public_ip
  description = "The public IP address of the Ansible server"
}