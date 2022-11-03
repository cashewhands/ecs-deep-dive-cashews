variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "environment" {
  type        = string
  description = "The deployment environment"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_count" {
  type        = number
  default     = 1
  description = "Number of resource created."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "public_subnets" {
  type        = list(string)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets" {
  type        = list(string)
  description = "The CIDR block for the private subnet"
}
