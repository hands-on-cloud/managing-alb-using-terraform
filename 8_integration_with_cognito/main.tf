locals {
  remote_state_bucket_region = "us-west-2"
  remote_state_bucket        = "hands-on-cloud-terraform-remote-state-s3"
  infrastructure_state_file  = "managing-alb-using-terraform-infrastructure.tfstate"
  alb_state_file             = "managing-alb-using-terraform-alb.tfstate"
  https_listener_state_file  = "managing-alb-using-terraform-alb-https-listener.tfstate"

  prefix          = data.terraform_remote_state.infrastructure.outputs.prefix
  common_tags     = data.terraform_remote_state.infrastructure.outputs.common_tags
  vpc_id          = data.terraform_remote_state.infrastructure.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.infrastructure.outputs.public_subnets
  private_subnets = data.terraform_remote_state.infrastructure.outputs.private_subnets

}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.infrastructure_state_file
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.alb_state_file
  }
}

data "terraform_remote_state" "https_listener" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.https_listener_state_file
  }
}
