data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "aws_subnets" "filtered_public" {
  for_each = toset(data.aws_availability_zones.availability_zones.zone_ids)

  filter {
    name   = "${var.app_name}-vpc-id"
    values = aws_vpc.vpc
  }

  filter {
    name   = "tag-key"
    values = ["public"]
  }

  filter {
    name   = "availability-zone-id"
    values = ["${each.value}"]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}