module "network" {
  source = "../../"

  name     = "example-inspection"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
  ]

  private_subnets = [
    { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
  ]

  transit_subnets = [
    { cidr = "10.0.201.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.202.0/24", availability_zone = "us-east-1b" },
  ]

  enable_gateway_lb          = true
  east_west_inspection_cidrs = ["10.1.0.0/16", "10.2.0.0/16"]

  enable_s3_endpoint   = true
  enable_vpc_flow_logs = true

  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}
