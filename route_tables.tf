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

resource "aws_route_table" "transit" {
  count = length(var.transit_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-transit-rt" })
}

resource "aws_route_table_association" "transit" {
  count = length(var.transit_subnets)

  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
