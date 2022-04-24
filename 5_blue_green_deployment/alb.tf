locals {
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
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 50
      }
    }
  }
}
