resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.app_name}-${var.environment}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
