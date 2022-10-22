variable "environment" {
  type        = string
  description = "Environment the deployment is targetting."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
}