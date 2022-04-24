output "alb_dns_name" {
  value = local.domain_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.web_https.arn
}
