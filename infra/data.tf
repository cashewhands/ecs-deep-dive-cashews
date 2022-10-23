data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "template_file" "env_vars" {
  template = file("env_vars.json")
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