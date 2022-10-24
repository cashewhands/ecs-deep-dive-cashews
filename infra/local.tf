locals {
  test = "this is the output"
  default_tags = merge(var.default_tags, {
    Environment = var.environment
  })
}