resource "aws_vpc_endpoint_service" "gwlb" {
  count = var.enable_gateway_lb ? 1 : 0

  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb[0].arn]

  tags = merge(local.common_tags, { Name = "${var.name}-gwlb-endpoint-svc" })
}

# One GWLB endpoint per transit subnet — maintains AZ affinity for inspection traffic
resource "aws_vpc_endpoint" "gwlb" {
  count = var.enable_gateway_lb ? length(var.transit_subnets) : 0

  service_name      = aws_vpc_endpoint_service.gwlb[0].service_name
  subnet_ids        = [aws_subnet.transit[count.index].id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-gwlb-endpoint-${count.index + 1}" })
}
