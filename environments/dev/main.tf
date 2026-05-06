module "cdn" {
  source = "../../modules/cloudfront"

  name           = "frontend-dev"
  s3_domain_name = module.s3.regional_domain_name
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "maki-frontend-dev"

  cloudfront_arn = module.cdn.cloudfront_arn
}
