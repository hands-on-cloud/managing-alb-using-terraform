locals {
  resource_name             = trimsuffix(substr("${local.prefix}-lambda", 0, 32), "-")
  alb_arn                   = data.terraform_remote_state.alb.outputs.alb_arn
  alb_sg                    = data.terraform_remote_state.alb.outputs.alb_security_group_id
}

# ------- ALB Security Group Rule --------

module "web_http_sg" {
  source = "terraform-aws-modules/security-group/aws"

  create_sg           = false
  security_group_id   = local.alb_sg
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = [
    "http-80-tcp",
    "https-443-tcp"
  ]
  egress_rules        = ["http-80-tcp"]
}

# ------- ALB Listener --------

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = local.alb_arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "web_https" {
  load_balancer_arn = local.alb_arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = aws_acm_certificate_validation.my_domain.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }
}

# ------- ALB Lambda Target Group --------

resource "aws_lb_target_group" "lambda" {
  name        = local.resource_name
  target_type = "lambda"

  tags = merge(
    {
      Name = local.resource_name
    },
    local.common_tags
  )
}

resource "aws_lambda_permission" "alb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.password_generator.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}

resource "aws_lb_target_group_attachment" "alb" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = aws_lambda_function.password_generator.arn
  depends_on       = [aws_lambda_permission.alb]
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.alb.outputs.alb_dns_name
    zone_id                = data.terraform_remote_state.alb.outputs.alb_dns_zone_id
    evaluate_target_health = true
  }
}
