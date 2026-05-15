output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_static_subnet_ids" {
  description = "A map of public static subnet IDs, keyed by availability zone."
  value       = { for k, v in aws_subnet.public_static : k => v.id }
}

output "private_static_subnet_ids" {
  description = "A map of private static subnet IDs, keyed by availability zone."
  value       = { for k, v in aws_subnet.private_static : k => v.id }
}

output "egress_static_subnet_ids" {
  description = "A map of egress static subnet IDs, keyed by availability zone."
  value       = { for k, v in aws_subnet.egress_static : k => v.id }
}

output "bastion_instance_eip" {
  description = "The public IP address of the Bastion instance."
  value       = aws_eip.bastion.public_ip
}