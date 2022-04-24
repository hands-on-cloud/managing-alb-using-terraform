locals {
  alb_url            = data.terraform_remote_state.https_listener.outputs.alb_dns_name
  https_listener_arn = data.terraform_remote_state.https_listener.outputs.alb_listener_arn
  target_group_arn   = data.terraform_remote_state.https_listener.outputs.alb_target_group_arn
  callback_urls      = ["https://${local.alb_url}/"]
  user_pool_domain   = "${local.prefix}-user-pool"
}

module "cognito" {
  source = "git::https://www.github.com/rhythmictech/terraform-aws-elb-cognito-auth?ref=v0.1.1"

  name                = local.user_pool_domain
  callback_urls       = local.callback_urls
  listener_arn        = local.https_listener_arn
  target_group_arn    = local.target_group_arn
  user_pool_domain    = local.user_pool_domain
  create_cognito_pool = true
}
