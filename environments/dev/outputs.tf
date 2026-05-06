output "cloudfront_url" {
  value = module.cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = module.cdn.distribution_id
}

output "s3_bucket" {
  value = module.s3.bucket_name
}