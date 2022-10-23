resource "aws_ecr_repository" "ecr" {
  name = "${var.app_name}-${var.environment}-ecr"

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
   encryption_type = "KMS"
  }
}