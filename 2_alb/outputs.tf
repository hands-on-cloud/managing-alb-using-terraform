output "alb_security_group_id" {
    value = module.alb_sg.security_group_id
}

output "alb_target_group_id" {
    value = aws_lb_target_group.web.id
}

output "alb_dns_name" {
    value = aws_lb.web.dns_name
}
