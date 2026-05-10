# terraform.example.tfvars — all available options

# Required
name = "my-vpc"

# CIDR block for the VPC
vpc_cidr = "10.0.0.0/16"

# Public subnets — each entry requires a cidr and availability_zone
public_subnets = [
  { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
  { cidr = "10.0.3.0/24", availability_zone = "us-east-1c" },
]

# Private subnets — each entry requires a cidr and availability_zone
private_subnets = [
  { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
  { cidr = "10.0.103.0/24", availability_zone = "us-east-1c" },
]

# Transit subnets — optional, used for TGW attachments or network appliances
# Omit or set to [] to skip
transit_subnets = [
  { cidr = "10.0.201.0/24", availability_zone = "us-east-1a" },
  { cidr = "10.0.202.0/24", availability_zone = "us-east-1b" },
  { cidr = "10.0.203.0/24", availability_zone = "us-east-1c" },
]

# Gateway Load Balancer for east-west traffic inspection
# Requires transit_subnets to be set. Set to false to skip all GWLB resources.
enable_gateway_lb             = true
gateway_lb_cross_zone_enabled = false

# CIDRs to route through GWLB endpoints in per-AZ transit route tables
# Typically the aggregate CIDR ranges of your spoke VPCs
east_west_inspection_cidrs = [
  "10.1.0.0/16", # spoke vpc a
  "10.2.0.0/16", # spoke vpc b
]

# VPC Flow Logs — enable to send ALL traffic metadata to CloudWatch
enable_vpc_flow_logs     = true
flow_logs_retention_days = 90

# Additional tags applied to every resource
tags = {
  Environment = "dev"
  Owner       = "platform-team"
  ManagedBy   = "terraform"
}
