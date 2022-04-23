locals {
  callback_urls      = ["https://managing-alb-using-terraform-1082358576.us-east-1.elb.amazonaws.com/"]
  https_listener_arn = data.terraform_remote_state.alb.outputs.https_listener_arn
  target_group_arn   = data.terraform_remote_state.alb.outputs.alb_target_group_id
  user_pool_domain   = "hands-on-cloud-alb"
}
module "cognitoauth" {
  source = "git::https://www.github.com/rhythmictech/terraform-aws-elb-cognito-auth?ref=v0.1.1"

  name                = "example"
  callback_urls       = local.callback_urls
  listener_arn        = local.https_listener_arn
  target_group_arn    = local.target_group_arn
  user_pool_domain    = local.user_pool_domain
  create_cognito_pool = true
}