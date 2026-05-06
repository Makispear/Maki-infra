resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac-${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = var.s3_domain_name
    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # AWS Managed: CachingOptimized
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
