resource "random_uuid" "s3_bucket_uuid" {

}

resource "aws_s3_bucket" "application_bucket" {
  bucket = random_uuid.s3_bucket_uuid.result
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_kms.arn
      }
    }
  }


  force_destroy = true

  tags = {
    Name = "application_s3_bucket"
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "application_bucket_lifecycle" {
  bucket = aws_s3_bucket.application_bucket.bucket

  rule {
    id     = "TransitionToStandardIA"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

locals {
  s3_bucket_name = aws_s3_bucket.application_bucket.bucket
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.application_bucket.bucket
  description = "Name of the S3 bucket for the application"
}