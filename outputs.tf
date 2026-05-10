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
  description = "Shared transit route table ID (null when GWLB is enabled — use transit_route_table_ids instead)"
  value       = length(aws_route_table.transit) > 0 ? aws_route_table.transit[0].id : null
}

output "transit_route_table_ids" {
  description = "All transit route table IDs — one shared table when GWLB disabled, one per AZ when GWLB enabled"
  value = var.enable_gateway_lb ? aws_route_table.transit_gwlb[*].id : (
    length(aws_route_table.transit) > 0 ? [aws_route_table.transit[0].id] : []
  )
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
  description = "Shared private route table ID (null when HA NAT is enabled — use private_route_table_ids instead)"
  value       = length(aws_route_table.private) > 0 ? aws_route_table.private[0].id : null
}

output "private_route_table_ids" {
  description = "All private route table IDs — one shared table normally, one per AZ when HA NAT enabled"
  value = (var.enable_nat_gateway && !var.single_nat_gateway) ? aws_route_table.private_nat[*].id : (
    length(aws_route_table.private) > 0 ? [aws_route_table.private[0].id] : []
  )
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (empty if not enabled)"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of Elastic IPs associated with NAT Gateways (empty if not enabled)"
  value       = aws_eip.nat[*].public_ip
}

output "gateway_lb_arn" {
  description = "ARN of the Gateway Load Balancer (null if not enabled)"
  value       = length(aws_lb.gwlb) > 0 ? aws_lb.gwlb[0].arn : null
}

output "gateway_lb_target_group_arn" {
  description = "ARN of the GWLB target group (null if not enabled)"
  value       = length(aws_lb_target_group.gwlb) > 0 ? aws_lb_target_group.gwlb[0].arn : null
}

output "gateway_lb_endpoint_service_name" {
  description = "Name of the GWLB VPC Endpoint Service (null if not enabled)"
  value       = length(aws_vpc_endpoint_service.gwlb) > 0 ? aws_vpc_endpoint_service.gwlb[0].service_name : null
}

output "gateway_lb_endpoint_ids" {
  description = "List of GWLB VPC Endpoint IDs, one per transit subnet AZ (empty if not enabled)"
  value       = aws_vpc_endpoint.gwlb[*].id
}

output "flow_log_id" {
  description = "VPC Flow Log ID (null if not enabled)"
  value       = length(aws_flow_log.this) > 0 ? aws_flow_log.this[0].id : null
}

output "flow_log_cloudwatch_log_group" {
  description = "CloudWatch Log Group name for VPC Flow Logs (null if not enabled)"
  value       = length(aws_cloudwatch_log_group.flow_logs) > 0 ? aws_cloudwatch_log_group.flow_logs[0].name : null
}

output "default_security_group_id" {
  description = "ID of the VPC default security group (locked down — no rules)"
  value       = aws_default_security_group.this.id
}
