module "s3_bucket" {
  source = "cloudposse/lb-s3-bucket/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  name                     = "${local.prefix}-access-log"
  access_log_bucket_name   = "${local.prefix}-access-log"
  access_log_bucket_prefix = "logs-"
  force_destroy            = true
}