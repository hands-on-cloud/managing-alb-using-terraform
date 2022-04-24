locals {
  resource_name             = trimsuffix(substr("${local.prefix}-ip-tg", 0, 32), "-")
  alb_arn                   = data.terraform_remote_state.alb.outputs.alb_arn
  alb_sg                    = data.terraform_remote_state.alb.outputs.alb_security_group_id
}

# ------- ALB Security Group Rule --------

module "web_http_sg" {
  source = "terraform-aws-modules/security-group/aws"

  create_sg           = false
  security_group_id   = local.alb_sg
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["http-80-tcp"]
}

# ------- ALB Listener --------

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = local.alb_arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ------- ALB Target Group --------

resource "aws_lb_target_group" "web" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    {
      Name = local.resource_name
    },
    local.common_tags
  )
}

# ------- Add EC2 IPs to ALB Target Group --------

resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.nginx)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.nginx[count.index].private_ip
  port             = 80
}
