# terraform.gateway.tfvars — east-west inspection with Gateway Load Balancer

name     = "inspection"
vpc_cidr = "10.0.0.0/16"

public_subnets = [
  { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
]

private_subnets = [
  { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
]

# Transit subnets host the GWLB and its per-AZ endpoints
transit_subnets = [
  { cidr = "10.0.201.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.202.0/24", availability_zone = "us-east-1b" },
]

# Enable GWLB — creates load balancer, target group, endpoint service, and per-AZ endpoints
enable_gateway_lb             = true
gateway_lb_cross_zone_enabled = false

# Spoke VPC CIDRs to route through GWLB endpoints in transit route tables
east_west_inspection_cidrs = [
  "10.1.0.0/16", # spoke vpc a
  "10.2.0.0/16", # spoke vpc b
]

# VPC Flow Logs
enable_vpc_flow_logs     = true
flow_logs_retention_days = 90

tags = {
  Environment = "prod"
  ManagedBy   = "terraform"
}
