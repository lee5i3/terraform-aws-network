locals {
  common_tags = merge(
    { Name = var.name },
    var.tags
  )

  nat_gateway_count = !var.enable_nat_gateway ? 0 : (var.single_nat_gateway ? 1 : length(var.public_subnets))

  # Flat list of {az_idx, cidr} pairs used to build per-AZ GWLB inspection routes
  transit_gwlb_routes = var.enable_gateway_lb ? flatten([
    for az_idx in range(length(var.transit_subnets)) : [
      for cidr in var.east_west_inspection_cidrs : {
        az_idx = az_idx
        cidr   = cidr
      }
    ]
  ]) : []
}
