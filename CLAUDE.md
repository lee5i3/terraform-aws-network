# CLAUDE.md — Project Context

This file documents the structure, decisions, and conventions for the `terraform-aws-network` module.
**Update this file whenever the module structure, variables, or design decisions change.**

## Purpose

A reusable Terraform module for provisioning an AWS VPC network with public, private, and optional transit subnets. Supports an optional Gateway Load Balancer (GWLB) for east-west traffic inspection.

## File Structure

| File | Purpose |
|---|---|
| `versions.tf` | Terraform and AWS provider version constraints |
| `variables.tf` | All input variables with types, descriptions, and defaults |
| `locals.tf` | Shared local values (common tags, GWLB route combinations) |
| `vpc.tf` | VPC resource |
| `internet_gateway.tf` | Internet Gateway |
| `subnets.tf` | Public, private, and optional transit subnets |
| `route_tables.tf` | Route tables and subnet associations |
| `gateway_lb.tf` | Optional GWLB, target group (GENEVE/6081), and listener |
| `gateway_lb_endpoints.tf` | Optional GWLB VPC Endpoint Service and per-AZ endpoints |
| `outputs.tf` | All module outputs |
| `terraform.example.tfvars` | Full example with every variable set |
| `terraform.minimal.tfvars` | Minimal example with required variables only |
| `MEMORY.md` | Running log of requests and changes — see below |

## Design Decisions

- Each subnet is defined as an object with `cidr` and `availability_zone` co-located, rather than parallel lists
- Transit subnets are optional (default `[]`) — no resources are created when omitted
- When `enable_gateway_lb = false`: one shared transit route table
- When `enable_gateway_lb = true`: one route table per transit subnet AZ, each routing `east_west_inspection_cidrs` through the AZ-local GWLB endpoint (maintains AZ affinity, avoids cross-AZ data charges)
- GWLB uses GENEVE protocol on port 6081 with a single default-forward listener
- One GWLB endpoint is created per transit subnet — endpoint service is auto-accepted
- All resources share a common tag set merged from `var.name` and `var.tags`

## East-West Inspection Flow

```
Spoke A → TGW → Inspection VPC transit subnet
  → GWLB Endpoint (per-AZ) → GWLB → Appliance
  → GWLB → GWLB Endpoint → TGW → Spoke B
```

## Conventions

- One resource type per file
- All resources use `count` for iteration
- Required variables have no default; optional variables have sensible defaults
- GWLB resources are fully count-gated on `var.enable_gateway_lb`

## Tracking

All requests and changes are logged in [MEMORY.md](MEMORY.md).
README.md should be kept up to date with current module capabilities.
