output "alb_dns_name" {
  value = data.terraform_remote_state.alb.outputs.alb_dns_name
}
