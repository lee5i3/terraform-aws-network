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

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
