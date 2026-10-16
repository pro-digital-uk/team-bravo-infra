variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name, used as a prefix for resource names and tagging."
  type        = string
  default     = "supando"
}

variable "environment_name" {
  description = "Environment identifier for tagging (e.g. mupando-dev, supando-dev)."
  type        = string
  default     = "dev"
}

variable "team_name" {
  description = "Team responsible for managing this infrastructure."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Environment name, for example dev, test or prod."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Web tier subnets, one per Availability Zone."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "App tier subnets, one per Availability Zone."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  description = "Data tier subnets, one per Availability Zone."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create a NAT Gateway for the app tier. COST WARNING: bills hourly plus data processing."
  type        = bool
  default     = false
}

variable "ssh_cidr_blocks" {
  description = "CIDR ranges allowed to reach the web tier via SSH. Only used when the security_groups module is enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "Instance type for the web and app servers."
  type        = string
  default     = "t2.micro"
}

variable "force_destroy_bucket" {
  description = "Let terraform destroy delete the S3 bucket even if it contains objects. Fine for a lab, not for production."
  type        = bool
  default     = true
}

variable "allowed_http_cidrs" {
  description = "CIDR ranges allowed to reach the web tier. Only used when the security_groups module is enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "az" {
  description = "Availability Zone to deploy into. Only used when the security_groups module is enabled."
  type        = string
  default     = "eu-west-2a"

}