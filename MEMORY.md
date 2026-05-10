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

### Feature: optional east-west GWLB
- Added `enable_gateway_lb` (bool, default false), `gateway_lb_cross_zone_enabled`, `east_west_inspection_cidrs` variables
- Created `gateway_lb.tf`: GWLB (type=gateway), GENEVE/6081 target group, listener
- Created `gateway_lb_endpoints.tf`: VPC Endpoint Service (auto-accept), one GWLB endpoint per transit subnet AZ
- Updated `route_tables.tf`: shared transit RT when GWLB disabled; per-AZ transit RTs with GWLB endpoint routes when enabled
- Updated `locals.tf`: added `transit_gwlb_routes` flat list for AZ × CIDR route combinations
- Updated `outputs.tf`: added GWLB ARN, TG ARN, endpoint service name, endpoint IDs, `transit_route_table_ids`
- Updated `terraform.example.tfvars` with GWLB options
- Updated `CLAUDE.md` with east-west flow diagram and revised design decisions

### tfvars examples
- Added `terraform.gateway.tfvars` for east-west GWLB setup
- Clarified comment in `terraform.minimal.tfvars`

## 2026-05-10

### Security + improvements
- **Variable validation**: added `can(cidrhost(...))` validation to all CIDR inputs; `length > 0` on `name`; valid CloudWatch retention value on `flow_logs_retention_days`
- **Cross-variable guards**: added `validations.tf` with `terraform_data` preconditions — GWLB requires transit subnets; inspection CIDRs require GWLB enabled
- **Default SG lockdown**: added `default_sg.tf` — `aws_default_security_group` with no rules (CIS AWS Benchmark 5.4)
- **VPC Flow Logs**: added `flow_logs.tf` — optional CloudWatch log group + scoped IAM role + `aws_flow_log` (traffic=ALL), gated on `enable_vpc_flow_logs`; added `flow_logs_retention_days` variable (default 90d)
- **CI**: added `.github/workflows/validate.yml` — runs `terraform fmt -check` + `terraform validate` on every PR and push to main
- **versions.tf**: bumped minimum Terraform to 1.4.0 (required for `terraform_data`)
- Updated `outputs.tf`, `terraform.example.tfvars`, `terraform.gateway.tfvars`, `CLAUDE.md`, `README.md`
