# terraform-aws-network

A Terraform module for provisioning an AWS VPC network with public, private, and optional transit subnets. Supports an optional Gateway Load Balancer (GWLB) for east-west traffic inspection.

## Resources Created

- VPC with DNS support and hostnames enabled
- Internet Gateway
- Public subnets (with `map_public_ip_on_launch`)
- Private subnets
- Transit subnets (optional — for TGW attachments or network appliances)
- Route tables and subnet associations for each tier
- Gateway Load Balancer, target group, and listener (optional)
- GWLB VPC Endpoint Service and per-AZ endpoints (optional)

## East-West Inspection Architecture

When `enable_gateway_lb = true`, the module sets up a centralized inspection path:

```
Spoke VPC A ──► TGW ──► Inspection VPC (transit subnet)
                              │
                    GWLB Endpoint (per-AZ)
                              │
                           GWLB ──► Appliance
                              │
                    GWLB Endpoint (per-AZ)
                              │
               TGW ──► Spoke VPC B
```

Each transit subnet gets its own route table with AZ-local GWLB endpoint routes, avoiding cross-AZ traffic.

## Usage

### Basic VPC

```hcl
module "network" {
  source = "github.com/lee5i3/terraform-aws-network"

  name     = "prod"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
  ]

  private_subnets = [
    { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
  ]
}
```

### With East-West GWLB Inspection

```hcl
module "network" {
  source = "github.com/lee5i3/terraform-aws-network"

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

  transit_subnets = [
    { cidr = "10.0.201.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.202.0/24", availability_zone = "us-east-1b" },
  ]

  enable_gateway_lb          = true
  east_west_inspection_cidrs = ["10.1.0.0/16", "10.2.0.0/16"]

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

See `terraform.example.tfvars` for all options and `terraform.minimal.tfvars` for a minimal configuration.

## Variables

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | required | Name prefix applied to all resources |
| `vpc_cidr` | `string` | `"10.0.0.0/16"` | CIDR block for the VPC |
| `public_subnets` | `list(object)` | 2 subnets in us-east-1a/b | Public subnet configs (`cidr`, `availability_zone`) |
| `private_subnets` | `list(object)` | 2 subnets in us-east-1a/b | Private subnet configs (`cidr`, `availability_zone`) |
| `transit_subnets` | `list(object)` | `[]` | Optional transit subnet configs (`cidr`, `availability_zone`) |
| `enable_gateway_lb` | `bool` | `false` | Enable GWLB for east-west inspection (requires `transit_subnets`) |
| `gateway_lb_cross_zone_enabled` | `bool` | `false` | Enable cross-zone load balancing on the GWLB |
| `east_west_inspection_cidrs` | `list(string)` | `[]` | CIDRs routed through per-AZ GWLB endpoints in transit route tables |
| `tags` | `map(string)` | `{}` | Additional tags applied to all resources |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC ID |
| `vpc_cidr` | VPC CIDR block |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `transit_subnet_ids` | List of transit subnet IDs |
| `internet_gateway_id` | Internet Gateway ID |
| `public_route_table_id` | Public route table ID |
| `private_route_table_id` | Private route table ID |
| `transit_route_table_id` | Shared transit route table ID (null when GWLB enabled) |
| `transit_route_table_ids` | All transit route table IDs (list — one per AZ when GWLB enabled) |
| `gateway_lb_arn` | GWLB ARN (null if not enabled) |
| `gateway_lb_target_group_arn` | GWLB target group ARN (null if not enabled) |
| `gateway_lb_endpoint_service_name` | GWLB endpoint service name (null if not enabled) |
| `gateway_lb_endpoint_ids` | List of GWLB VPC endpoint IDs, one per transit subnet AZ |

## Requirements

| Name | Version |
|---|---|
| Terraform | >= 1.3.0 |
| AWS provider | >= 5.0 |
