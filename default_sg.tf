# Remove all rules from the default security group (CIS AWS Benchmark 5.4)
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-default-sg-DO-NOT-USE" })
}
