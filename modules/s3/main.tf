# create the bucket to host the dist file
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudfront.amazonaws.com"
      },
      Action   = "s3:GetObject",
      Resource = "${aws_s3_bucket.this.arn}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = var.cloudfront_arn
        }
      }
    }]
  })
}
