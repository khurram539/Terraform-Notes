output "ansible_server_ip" {
  value = aws_instance.ansible_server[0].public_ip
}