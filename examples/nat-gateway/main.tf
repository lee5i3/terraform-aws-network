module "network" {
  source = "../../"

  name     = "example-nat"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
  ]

  private_subnets = [
    { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
  ]

  # HA NAT — one NAT GW per public subnet AZ
  enable_nat_gateway = true
  single_nat_gateway = false

  enable_s3_endpoint   = true
  enable_vpc_flow_logs = true

  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}
