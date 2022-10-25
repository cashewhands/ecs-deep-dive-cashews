variable "region" {
  type        = string
  description = "AWS Region"
}

variable "environment" {
  type        = string
  description = "Environment the deployment is targetting."
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_count" {
  type        = number
  default     = 3
  description = "Number of resource created."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}
