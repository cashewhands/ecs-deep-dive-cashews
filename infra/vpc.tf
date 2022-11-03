# vpc.tf | VPC Configuration

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_flow_log" "vpc-fl" {
  iam_role_arn         = aws_iam_role.vpc-fl.arn
  log_destination      = aws_s3_bucket.vpc-fl-bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}