resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Shared transit route table — used when GWLB is disabled
resource "aws_route_table" "transit" {
  count = length(var.transit_subnets) > 0 && !var.enable_gateway_lb ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-transit-rt" })
}

resource "aws_route_table_association" "transit" {
  count = !var.enable_gateway_lb ? length(var.transit_subnets) : 0

  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit[0].id
}

# Per-AZ transit route tables — used when GWLB is enabled to maintain AZ-local endpoint routing
resource "aws_route_table" "transit_gwlb" {
  count = var.enable_gateway_lb ? length(var.transit_subnets) : 0

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-transit-rt-${count.index + 1}" })
}

resource "aws_route" "transit_gwlb_inspection" {
  count = length(local.transit_gwlb_routes)

  route_table_id         = aws_route_table.transit_gwlb[local.transit_gwlb_routes[count.index].az_idx].id
  destination_cidr_block = local.transit_gwlb_routes[count.index].cidr
  vpc_endpoint_id        = aws_vpc_endpoint.gwlb[local.transit_gwlb_routes[count.index].az_idx].id
}

resource "aws_route_table_association" "transit_gwlb" {
  count = var.enable_gateway_lb ? length(var.transit_subnets) : 0

  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit_gwlb[count.index].id
}

# Shared private route table — used when NAT HA is not enabled
resource "aws_route_table" "private" {
  count = (var.enable_nat_gateway && !var.single_nat_gateway) ? 0 : 1

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route" "private_nat_single" {
  count = (var.enable_nat_gateway && var.single_nat_gateway) ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count = (var.enable_nat_gateway && !var.single_nat_gateway) ? 0 : length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# Per-AZ private route tables — used when HA NAT is enabled (single_nat_gateway = false)
resource "aws_route_table" "private_nat" {
  count = (var.enable_nat_gateway && !var.single_nat_gateway) ? length(var.private_subnets) : 0

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-rt-${count.index + 1}" })
}

resource "aws_route" "private_nat_ha" {
  count = (var.enable_nat_gateway && !var.single_nat_gateway) ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private_nat[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index % local.nat_gateway_count].id
}

resource "aws_route_table_association" "private_nat" {
  count = (var.enable_nat_gateway && !var.single_nat_gateway) ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_nat[count.index].id
}
