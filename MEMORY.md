# MEMORY.md — Request & Change Log

A chronological record of requests and the changes made to this module.
Reference this when onboarding, auditing, or understanding why something was built a certain way.

---

## 2026-05-09

### Init
- Created repo `terraform-aws-network` with `main` branch and README placeholder

### Feature: basic VPC
- Added `versions.tf`, `variables.tf`, `main.tf`, `outputs.tf`
- Resources: VPC, IGW, public/private subnets, route tables + associations

### Refactor: per-subnet CIDR
- Changed `public_subnet_cidrs` + `private_subnet_cidrs` + `availability_zones` (separate lists) to `public_subnets` + `private_subnets` (list of objects with `cidr` + `availability_zone`)

### Refactor: split files
- Broke `main.tf` into `locals.tf`, `vpc.tf`, `internet_gateway.tf`, `subnets.tf`, `route_tables.tf`

### Feature: tfvars examples
- Added `terraform.example.tfvars` (all options) and `terraform.minimal.tfvars` (required only)

### Feature: transit subnets
- Added optional `transit_subnets` variable (default `[]`)
- Added `aws_subnet.transit`, `aws_route_table.transit`, associations, and outputs
- Updated `terraform.example.tfvars` with transit subnet example

### Docs: CLAUDE.md + MEMORY.md + README
- Added `CLAUDE.md` for project context and conventions
- Added `MEMORY.md` (this file) for request tracking
- Updated `README.md` with full module documentation
