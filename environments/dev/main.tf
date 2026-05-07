module "s3" {
  source      = "../../modules/s3"
  bucket_name = "maki-frontend-dev"

  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  name           = "frontend-dev"
  s3_domain_name = module.s3.regional_domain_name
}

resource "github_actions_secret" "cloudfront_id_secret" {
  repository  = "Maki-Maki"
  secret_name = "CLOUDFRONT_DIST_ID"

  # 'value' is the modern replacement for 'plaintext_value'
  value = module.cloudfront.distribution_id
}

# 4. Update GitHub Variables
resource "github_actions_variable" "s3_bucket_var" {
  repository    = "Maki-Maki"
  variable_name = "S3_BUCKET_NAME"
  value         = module.s3.bucket_name
}
