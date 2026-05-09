variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
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
}

variable "transit_subnets" {
  description = "Optional list of transit subnet configurations (e.g. for TGW attachments or network appliances), each with a cidr and availability_zone"
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  default = []
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
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
