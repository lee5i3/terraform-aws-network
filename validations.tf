# Cross-variable preconditions that cannot be expressed in variable validation blocks

resource "terraform_data" "gwlb_requires_transit_subnets" {
  lifecycle {
    precondition {
      condition     = !var.enable_gateway_lb || length(var.transit_subnets) > 0
      error_message = "enable_gateway_lb = true requires at least one transit_subnet to be configured."
    }
  }
}

resource "terraform_data" "gwlb_inspection_cidrs_require_gwlb" {
  lifecycle {
    precondition {
      condition     = length(var.east_west_inspection_cidrs) == 0 || var.enable_gateway_lb
      error_message = "east_west_inspection_cidrs are only used when enable_gateway_lb = true."
    }
  }
}
