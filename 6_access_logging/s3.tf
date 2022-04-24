module "s3_bucket" {
  source = "cloudposse/lb-s3-bucket/aws"

  name                     = local.resource_name
  access_log_bucket_name   = local.resource_name
  access_log_bucket_prefix = local.resource_name
  force_destroy            = true
}
