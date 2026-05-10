variable "name" {
  description = "Name prefix for all resources"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "name must not be empty."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block (e.g. \"10.0.0.0/16\")."
  }
}

variable "public_subnets" {
  description = "List of public subnet configurations, each with a cidr and availability_zone"
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  default = [
    { cidr = "10.0.1.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.2.0/24", availability_zone = "us-east-1b" },
  ]

  validation {
    condition     = alltrue([for s in var.public_subnets : can(cidrhost(s.cidr, 0))])
    error_message = "Each public_subnet must have a valid IPv4 CIDR block."
  }
}

variable "private_subnets" {
  description = "List of private subnet configurations, each with a cidr and availability_zone"
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  default = [
    { cidr = "10.0.101.0/24", availability_zone = "us-east-1a" },
    { cidr = "10.0.102.0/24", availability_zone = "us-east-1b" },
  ]

  validation {
    condition     = alltrue([for s in var.private_subnets : can(cidrhost(s.cidr, 0))])
    error_message = "Each private_subnet must have a valid IPv4 CIDR block."
  }
}

variable "transit_subnets" {
  description = "Optional list of transit subnet configurations (e.g. for TGW attachments or network appliances), each with a cidr and availability_zone"
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  default = []

  validation {
    condition     = alltrue([for s in var.transit_subnets : can(cidrhost(s.cidr, 0))])
    error_message = "Each transit_subnet must have a valid IPv4 CIDR block."
  }
}

variable "enable_gateway_lb" {
  description = "Enable a Gateway Load Balancer in transit subnets for east-west traffic inspection. Requires transit_subnets to be set."
  type        = bool
  default     = false
}

variable "gateway_lb_cross_zone_enabled" {
  description = "Enable cross-zone load balancing on the Gateway Load Balancer"
  type        = bool
  default     = false
}

variable "east_west_inspection_cidrs" {
  description = "CIDRs to route through GWLB endpoints in per-AZ transit route tables (only used when enable_gateway_lb = true)"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.east_west_inspection_cidrs : can(cidrhost(c, 0))])
    error_message = "Each east_west_inspection_cidr must be a valid IPv4 CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway(s) for private subnet outbound internet access. Requires at least one public subnet."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway (cost saving) instead of one per public subnet AZ (high availability)"
  type        = bool
  default     = false
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch Logs"
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Retention period in days for the VPC Flow Logs CloudWatch log group"
  type        = number
  default     = 90

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.flow_logs_retention_days)
    error_message = "flow_logs_retention_days must be a valid CloudWatch log retention value."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
