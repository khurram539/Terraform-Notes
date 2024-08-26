output "vpc1_id" {
  description = "The ID of the first VPC"
  value       = aws_vpc.vpc1.id
}

output "vpc2_id" {
  description = "The ID of the second VPC"
  value       = aws_vpc.vpc2.id
}

output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peer.id
}