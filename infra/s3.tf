resource "aws_s3_bucket" "default" {
  #checkov:skip=CKV_AWS_19:Data stored in the S3 bucket is not securely encrypted at rest
  #checkov:skip=CKV_AWS_28: Will add to this later
  #checkov:skip=CKV_AWS_145: Will add to this later
  #checkov:skip=CKV_AWS_18: Ensure AWS access logging is enabled on S3 buckets
  #checkov:skip=CKV_AWS_144: No need for cross-region replication
  bucket = "cashewhands-s3-bucket"
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}