variable "environment" {
  type        = string
  description = "Environment the deployment is targetting."
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