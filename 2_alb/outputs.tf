output "alb_security_group_id" {
  value = module.alb_sg.security_group_id
}

output "alb_target_group_id" {
  value = aws_lb_target_group.web.id
}

output "sample_tg" {
  value = aws_lb_target_group.sample.id
}

output "blue_tg" {
  value = aws_lb_target_group.bluetg.id
}

output "green_tg" {
  value = aws_lb_target_group.greentg.id
}

output "lambda_tg" {
  value = aws_lb_target_group.lambdatg.id
}
output "asg_tg" {
  value = aws_lb_target_group.autoscale.id
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn" {
  value = aws_lb.web.arn
}

output "listener_arn" {
  value = aws_lb_listener.web_http.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}