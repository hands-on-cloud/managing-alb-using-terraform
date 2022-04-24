locals {
  prefix   = "managing-alb-using-terraform"
  vpc_name = "${local.prefix}-vpc"
  vpc_cidr = "10.10.0.0/16"
  common_tags = {
    Environment = "dev"
    Project     = "hands-on.cloud"
  }
}
