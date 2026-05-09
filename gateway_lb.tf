resource "aws_lb" "gwlb" {
  count = var.enable_gateway_lb ? 1 : 0

  name               = "${var.name}-gwlb"
  load_balancer_type = "gateway"
  subnets            = aws_subnet.transit[*].id

  enable_cross_zone_load_balancing = var.gateway_lb_cross_zone_enabled

  tags = merge(local.common_tags, { Name = "${var.name}-gwlb" })
}

resource "aws_lb_target_group" "gwlb" {
  count = var.enable_gateway_lb ? 1 : 0

  name     = "${var.name}-gwlb-tg"
  port     = 6081
  protocol = "GENEVE"
  vpc_id   = aws_vpc.this.id

  health_check {
    port     = "80"
    protocol = "HTTP"
  }

  tags = merge(local.common_tags, { Name = "${var.name}-gwlb-tg" })
}

resource "aws_lb_listener" "gwlb" {
  count = var.enable_gateway_lb ? 1 : 0

  load_balancer_arn = aws_lb.gwlb[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb[0].arn
  }
}
