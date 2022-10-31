locals {
  
  default_tags = merge(var.default_tags, {
    Environment = var.environment
  })
  public_subnets_ids = [for k, v in data.aws_subnets.filtered_public : v.ids[0]]
  test = "this is the output"
}