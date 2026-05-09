# CLAUDE.md — Project Context

This file documents the structure, decisions, and conventions for the `terraform-aws-network` module.
**Update this file whenever the module structure, variables, or design decisions change.**

## Purpose

A reusable Terraform module for provisioning a basic AWS VPC network, including public, private, and optional transit subnets with associated route tables.

## File Structure

| File | Purpose |
|---|---|
| `versions.tf` | Terraform and AWS provider version constraints |
| `variables.tf` | All input variables with types, descriptions, and defaults |
| `locals.tf` | Shared local values (common tags) |
| `vpc.tf` | VPC resource |
| `internet_gateway.tf` | Internet Gateway |
| `subnets.tf` | Public, private, and optional transit subnets |
| `route_tables.tf` | Route tables and subnet associations |
| `outputs.tf` | All module outputs |
| `terraform.example.tfvars` | Full example with every variable set |
| `terraform.minimal.tfvars` | Minimal example with required variables only |
| `MEMORY.md` | Running log of requests and changes — see below |

## Design Decisions

- Each subnet is defined as an object with `cidr` and `availability_zone` co-located, rather than parallel lists
- Transit subnets are optional (default `[]`) — no resources are created when omitted
- A single transit route table is shared across all transit subnets
- All resources share a common tag set merged from `var.name` and `var.tags`

## Conventions

- One resource type per file
- All resources use `count` (not `for_each`) for subnet iteration
- Required variables have no default; optional variables have sensible defaults

## Tracking

All requests and changes are logged in [MEMORY.md](MEMORY.md).
README.md should be kept up to date with current module capabilities.
