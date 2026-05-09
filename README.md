# terraform-aws-network

A Terraform module for provisioning a VPC network on AWS with public, private, and optional transit subnets.

## Resources Created

- VPC with DNS support and hostnames enabled
- Internet Gateway
- Public subnets (with `map_public_ip_on_launch`)
- Private subnets
- Transit subnets (optional — for TGW attachments or network appliances)
- Route tables and subnet associations for each tier

## Usage

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

  # Optional — omit to skip transit subnet creation
  transit_subnets = [
    { cidr = "10.0.201.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.202.0/24", availability_zone = "us-east-1b" },
  ]

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
| `tags` | `map(string)` | `{}` | Additional tags applied to all resources |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC ID |
| `vpc_cidr` | VPC CIDR block |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `transit_subnet_ids` | List of transit subnet IDs (empty if none configured) |
| `internet_gateway_id` | Internet Gateway ID |
| `public_route_table_id` | Public route table ID |
| `private_route_table_id` | Private route table ID |
| `transit_route_table_id` | Transit route table ID (null if no transit subnets) |

## Requirements

| Name | Version |
|---|---|
| Terraform | >= 1.3.0 |
| AWS provider | >= 5.0 |
