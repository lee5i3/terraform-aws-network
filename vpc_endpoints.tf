data "aws_region" "current" {}

# S3 Gateway endpoint — free, keeps S3 traffic off the public internet and NAT GW
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [aws_route_table.public.id],
    aws_route_table.private[*].id,
    aws_route_table.private_nat[*].id,
    aws_route_table.transit[*].id,
  )

  tags = merge(local.common_tags, { Name = "${var.name}-s3-endpoint" })
}
