resource "aws_ecr_repository" "ecr" {
  name = "${var.app_name}-${var.environment}-ecr"
}