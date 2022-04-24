output "alb_security_group_id" {
  value = module.alb_sg.security_group_id
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn" {
  value = aws_lb.web.arn
}

output "alb_dns_zone_id" {
  value = aws_lb.web.zone_id
}
