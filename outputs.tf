output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "transit_subnet_ids" {
  description = "List of transit subnet IDs (empty if none configured)"
  value       = aws_subnet.transit[*].id
}

output "transit_route_table_id" {
  description = "The ID of the transit route table (null if no transit subnets configured)"
  value       = length(aws_route_table.transit) > 0 ? aws_route_table.transit[0].id : null
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}
