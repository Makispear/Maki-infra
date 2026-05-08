module "s3" {
  source         = "../../modules/s3"
  bucket_name    = "maki-portfolio-dev"
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cloudfront" {
  source         = "../../modules/cloudfront"
  name           = "frontend-dev"
  s3_domain_name = module.s3.regional_domain_name
}

resource "github_repository_environment" "develop" {
  repository  = "Maki-Maki"
  environment = "develop"
}

resource "github_actions_environment_secret" "cloudfront_id_secret" {
  repository  = "Maki-Maki"
  environment = github_repository_environment.develop.environment
  secret_name = "CLOUDFRONT_DIST_ID"
  value       = module.cloudfront.distribution_id
}

resource "github_actions_environment_variable" "s3_bucket_var" {
  repository    = "Maki-Maki"
  environment   = github_repository_environment.develop.environment
  variable_name = "S3_BUCKET_NAME"
  value         = module.s3.bucket_name
}

# This syncs your Access Key ID
resource "github_actions_environment_secret" "aws_key" {
  repository  = "Maki-Maki"
  environment = "develop"
  secret_name = "AWS_ACCESS_KEY_ID"
  value       = var.aws_access_key_id
}

# This syncs your Secret Access Key
resource "github_actions_environment_secret" "aws_secret" {
  repository  = "Maki-Maki"
  environment = "develop"
  secret_name = "AWS_SECRET_ACCESS_KEY"
  value       = var.aws_secret_access_key
}
